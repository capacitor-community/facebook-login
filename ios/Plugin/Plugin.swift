import Foundation
import Capacitor
import FBSDKLoginKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(FacebookLogin)
public class FacebookLogin: CAPPlugin {
    private let loginManager = LoginManager()
    private let dateFormatter = ISO8601DateFormatter()

    override public func load() {
        if #available(iOS 11.2, *) {
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        } else {
            dateFormatter.formatOptions = [.withInternetDateTime]
        }

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


        DispatchQueue.main.async {
            self.loginManager.logIn(permissions: permissions, from: self.bridge?.viewController) { result, error in
                if let error = error {
                    print(error)
                    call.reject("LoginManager.logIn failed")
                } else if let result = result, result.isCancelled {
                    print("User cancelled login")
                    call.resolve()
                } else {
                    print("Logged in")
                    return self.getCurrentAccessToken(call)
                }
            }
        }
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

    private func accessTokenToJson(_ accessToken: AccessToken) -> [String: Any?] {
        return [
            "applicationId": accessToken.appID,
            /*declinedPermissions: accessToken.declinedPermissions,*/
            "expires": dateToJS(accessToken.expirationDate),
            "lastRefresh": dateToJS(accessToken.refreshDate),
            /*permissions: accessToken.grantedPermissions,*/
            "token": accessToken.tokenString,
            "userId": accessToken.userID
        ]
    }

    @objc func getCurrentAccessToken(_ call: CAPPluginCall) {
        guard let accessToken = AccessToken.current else {
            call.resolve()
            return
        }

        call.resolve([ "accessToken": accessTokenToJson(accessToken) ])
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
        if let name = call.getString("name") {
            AppEvents.shared.logEvent(AppEvents.Name(name))
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
        if let enabled = call.getBool("enabled") {
            Settings.shared.isAdvertiserTrackingEnabled = enabled
        } else {
            Settings.shared.isAdvertiserTrackingEnabled = false
        }
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
