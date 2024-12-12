import Foundation
import Capacitor
import FBSDKLoginKit
import CryptoKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
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

    private let loginManager = LoginManager()
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

        var configuration: LoginConfiguration?

        if nonce.isEmpty {
            configuration = LoginConfiguration(
                permissions: permissions,
                tracking: tracking == "limited" ? .limited : .enabled
            )
        } else {
            configuration = LoginConfiguration(
                permissions: permissions,
                tracking: tracking == "limited" ? .limited : .enabled,
                nonce: self.sha256(nonce)
            )
        }

        guard let _ = configuration else {
            // エラー処理
            return
        }

        DispatchQueue.main.async {
            self.loginManager.logIn(configuration: configuration) { result in
                switch result {
                case .cancelled:
                    print("User cancelled login")
                    call.resolve()
                case .failed:
                    call.reject("LoginManager.logIn failed")
                case .success:
                    print("Logged in")
                    return self.getCurrentAccessToken(call)
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
        loginManager.logOut()
        call.resolve()
    }

    @objc func reauthorize(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            if let token = AccessToken.current, !token.isDataAccessExpired {
                return self.getCurrentAccessToken(call)
            } else {
                self.loginManager.reauthorizeDataAccess(from: (self.bridge?.viewController)!) { (loginResult, error) in
                    if (loginResult?.token) != nil {
                        return self.getCurrentAccessToken(call)
                    } else {
                        print(error!)
                        call.reject("LoginManager.reauthorize failed")
                    }
                }
            }
        }
    }

    @objc func getCurrentAccessToken(_ call: CAPPluginCall) {
        guard let authenticationToken = AuthenticationToken.current else {
            call.resolve()
            return
        }

        guard let userProfile = Profile.current else {
            call.resolve()
            return
        }

        call.resolve([ "accessToken": [
            "token": authenticationToken.tokenString,
            "userId": userProfile.userID,
            "name": userProfile.name,
            "email": userProfile.email
        ]
        ])
    }

    @objc func getProfile(_ call: CAPPluginCall) {
        guard let accessToken = AccessToken.current else {
            call.reject("You're not logged in. Call FacebookLogin.login() first to obtain an access token.")
            return
        }

        if accessToken.isExpired {
            call.reject("AccessToken is expired.")
            return
        }

        guard let fields = call.getArray("fields", String.self) else {
            call.reject("Missing fields argument")
            return
        }
        let parameters = ["fields": fields.joined(separator: ",")]
        let graphRequest = GraphRequest.init(graphPath: "me", parameters: parameters)

        graphRequest.start { (_ connection, _ result, _ error) in
            if error != nil {
                call.reject("An error has been occured.")
                return
            }

            call.resolve(result as! [String: Any])
        }
    }

    @objc func logEvent(_ call: CAPPluginCall) {
        if let eventName = call.getString("eventName") {
            AppEvents.shared.logEvent(AppEvents.Name(eventName))
        }

        call.resolve()
    }

    @objc func setAutoLogAppEventsEnabled(_ call: CAPPluginCall) {
        if let enabled = call.getBool("enabled") {
            Settings.shared.isAutoLogAppEventsEnabled = enabled
        } else {
            Settings.shared.isAutoLogAppEventsEnabled = false
        }
        call.resolve()
    }

    @objc func setAdvertiserTrackingEnabled(_ call: CAPPluginCall) {
        Settings.shared.isAdvertiserTrackingEnabled = call.getBool("enabled", false)
        call.resolve()
    }

    @objc func setAdvertiserIDCollectionEnabled(_ call: CAPPluginCall) {
        if let enabled = call.getBool("enabled") {
            Settings.shared.isAdvertiserIDCollectionEnabled = enabled
        } else {
            Settings.shared.isAdvertiserIDCollectionEnabled = false
        }
        call.resolve()
    }
}
