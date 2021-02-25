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

    @objc func login(_ call: CAPPluginCall) {
        guard let permissions = call.getArray("permissions", String.self) else {
            call.error("Missing permissions argument")
            return
        }

        let perm = permissions.map { Permission.custom($0) }

        DispatchQueue.main.async {
            self.loginManager.logIn(permissions: perm, viewController: self.bridge?.viewController) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                    call.reject("LoginManager.logIn failed")

                case .cancelled:
                    print("User cancelled login")
                    call.success()

                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("Logged in")
                    return self.getCurrentAccessToken(call)
                }
            }
        }
    }

    @objc func logout(_ call: CAPPluginCall) {
        loginManager.logOut()

        call.success()
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
            call.success()
            return
        }

        call.success([ "accessToken": accessTokenToJson(accessToken) ])
    }

    @objc func getProfile(_ call: CAPPluginCall) {
        guard let accessToken = AccessToken.current else {
            call.error("You're not logged in. Call FacebookLogin.login() first to obtain an access token.")
            return
        }

        if accessToken.isExpired {
            call.error("AccessToken is expired.")
            return
        }

        guard let fields = call.getArray("fields", String.self) else {
            call.error("Missing fields argument")
            return
        }
        let parameters = ["fields": fields.joined(separator: ",")]
        let graphRequest = GraphRequest.init(graphPath: "me", parameters: parameters)

        graphRequest.start { (_ connection, _ result, _ error) in
            if error != nil {
                call.error("An error has been occured.", error)
                return
            }

            call.success(result as! [String: Any])
        }
    }
}
