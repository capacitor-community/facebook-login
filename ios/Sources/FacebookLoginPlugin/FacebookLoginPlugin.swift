import Foundation
import Capacitor
import CryptoKit

/**
 * Facebook Login Plugin for Capacitor
 * Uses Objective-C helper to avoid Swift API gating issues with FBSDK 18's NonescapableTypes requirement
 */
@objc(FacebookLoginPlugin)
public class FacebookLoginPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "FacebookLoginPlugin"
    public let jsName = "FacebookLogin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "login", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "logout", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getCurrentAccessToken", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getProfile", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "reauthorize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "logEvent", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setAutoLogAppEventsEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setAdvertiserTrackingEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setAdvertiserIDCollectionEnabled", returnType: CAPPluginReturnPromise)
    ]

    private let dateFormatter = ISO8601DateFormatter()

    override public func load() {
        dateFormatter.formatOptions = [.withInternetDateTime]
    }

    private func dateToJS(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    @objc func initialize(_ call: CAPPluginCall) {
        call.resolve()
    }

    @objc func login(_ call: CAPPluginCall) {
        guard let permissions = call.getArray("permissions", String.self) else {
            call.reject("Missing permissions argument")
            return
        }

        let nonce = call.getString("nonce") ?? ""
        let tracking = call.getString("tracking") ?? "limited"
        let trackingEnabled = tracking != "limited"

        let hashedNonce = nonce.isEmpty ? nil : sha256(nonce)

        DispatchQueue.main.async {
            guard let viewController = self.bridge?.viewController else {
                call.reject("Missing view controller.")
                return
            }
            
            FBSDKLoginHelper.login(from: viewController,
                                   permissions: permissions,
                                   trackingEnabled: trackingEnabled,
                                   nonce: hashedNonce) { success, cancelled, errorMessage in
                if cancelled {
                    print("User cancelled login")
                    call.resolve()
                    return
                }
                
                if let error = errorMessage {
                    call.reject("LoginManager.logIn failed: \(error)")
                    return
                }
                
                if success {
                    print("Logged in")
                    self.getCurrentAccessToken(call)
                } else {
                    call.reject("Login failed")
                }
            }
        }
    }

    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    @objc func logout(_ call: CAPPluginCall) {
        FBSDKLoginHelper.logOut()
        call.resolve()
    }

    @objc func reauthorize(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            // Check if we already have valid access
            if FBSDKLoginHelper.hasCurrentAccessToken() && !FBSDKLoginHelper.isDataAccessExpired() {
                self.getCurrentAccessToken(call)
                return
            }

            guard let viewController = self.bridge?.viewController else {
                call.reject("Missing view controller.")
                return
            }

            FBSDKLoginHelper.reauthorizeDataAccess(from: viewController) { success, cancelled, errorMessage in
                if cancelled {
                    call.resolve()
                    return
                }
                
                if let error = errorMessage {
                    call.reject("LoginManager.reauthorize failed: \(error)")
                    return
                }
                
                if success {
                    self.getCurrentAccessToken(call)
                } else {
                    call.reject("Reauthorization failed")
                }
            }
        }
    }

    @objc func getCurrentAccessToken(_ call: CAPPluginCall) {
        guard FBSDKLoginHelper.hasCurrentAccessToken() else {
            call.resolve()
            return
        }

        var accessTokenPayload: [String: Any] = [:]

        if let tokenString = FBSDKLoginHelper.currentTokenString() {
            accessTokenPayload["token"] = tokenString
        }

        if let userId = FBSDKLoginHelper.currentUserID() {
            accessTokenPayload["userId"] = userId
            
            // Fetch profile info via Graph API
            let parameters = ["fields": "id,name,email"]
            FBSDKLoginHelper.graphRequest(withPath: "me", parameters: parameters) { result, errorMessage in
                if let result = result {
                    if let userId = result["id"] as? String {
                        accessTokenPayload["userId"] = userId
                    }
                    if let name = result["name"] as? String {
                        accessTokenPayload["name"] = name
                    }
                    if let email = result["email"] as? String {
                        accessTokenPayload["email"] = email
                    }
                }
                call.resolve(["accessToken": accessTokenPayload])
            }
            return
        }

        call.resolve(["accessToken": accessTokenPayload])
    }

    @objc func getProfile(_ call: CAPPluginCall) {
        guard FBSDKLoginHelper.hasCurrentAccessToken() else {
            call.reject("You're not logged in. Call FacebookLogin.login() first to obtain an access token.")
            return
        }

        if FBSDKLoginHelper.isAccessTokenExpired() {
            call.reject("AccessToken is expired.")
            return
        }

        guard let fields = call.getArray("fields", String.self) else {
            call.reject("Missing fields argument")
            return
        }
        
        let parameters = ["fields": fields.joined(separator: ",")]

        FBSDKLoginHelper.graphRequest(withPath: "me", parameters: parameters) { result, errorMessage in
            if let error = errorMessage {
                call.reject("An error has occurred: \(error)")
                return
            }

            if let result = result {
                // Convert [AnyHashable: Any] to [String: Any]
                var stringKeyedResult: [String: Any] = [:]
                for (key, value) in result {
                    if let stringKey = key as? String {
                        stringKeyedResult[stringKey] = value
                    }
                }
                call.resolve(stringKeyedResult)
            } else {
                call.reject("An error has occurred.")
            }
        }
    }

    @objc func logEvent(_ call: CAPPluginCall) {
        if let eventName = call.getString("eventName") {
            FBSDKLoginHelper.logEvent(withName: eventName)
        }
        call.resolve()
    }

    @objc func setAutoLogAppEventsEnabled(_ call: CAPPluginCall) {
        let enabled = call.getBool("enabled") ?? false
        FBSDKLoginHelper.setAutoLogAppEventsEnabled(enabled)
        call.resolve()
    }

    @objc func setAdvertiserTrackingEnabled(_ call: CAPPluginCall) {
        let enabled = call.getBool("enabled") ?? false
        FBSDKLoginHelper.setAdvertiserTrackingEnabled(enabled)
        call.resolve()
    }

    @objc func setAdvertiserIDCollectionEnabled(_ call: CAPPluginCall) {
        let enabled = call.getBool("enabled") ?? false
        FBSDKLoginHelper.setAdvertiserIDCollectionEnabled(enabled)
        call.resolve()
    }
}
