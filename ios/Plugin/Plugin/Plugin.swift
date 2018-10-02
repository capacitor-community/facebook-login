import Foundation
import Capacitor
import FacebookCore
import FBSDKLoginKit

@objc(FacebookLogin)
public class FacebookLogin: CAPPlugin {
    private let sdkManager: FBSDKLoginManager = FBSDKLoginManager()
    private let dateFormatter = ISO8601DateFormatter()
    
    override public func load() {
        if #available(iOS 11, *) {
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        } else {
            dateFormatter.formatOptions = [.withInternetDateTime]
        }
    }

    private func dateToJS(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    @objc func login(_ call: CAPPluginCall) {
        let permissions = call.getArray("permissions", String.self)
        
        sdkManager.logIn(withReadPermissions: permissions, from: bridge.viewController, handler: { (result, error) -> Void in
            if let error = error {
                FBSDKLoginManager().logOut()
                
                call.reject("FBSDKLoginManager.logIn failed", error)
            } else if let result = result {
                if result.isCancelled {
                    call.reject("Cancelled by user")
                } else {
                    return self.getCurrentAccessToken(call)
                }
            } else {
                call.reject("FBSDKLoginManager.logIn: no result");
            }
        })
    }
    
    @objc func logout(_ call: CAPPluginCall) {
        FBSDKLoginManager().logOut()
        
        call.success()
    }
    
    private func accessTokenToJson(_ accessToken: AccessToken) -> [String: Any?] {
        return [
            "applicationId": accessToken.appId,
            /*declinedPermissions: accessToken.declinedPermissions,*/
            "expires": dateToJS(accessToken.expirationDate),
            "lastRefresh": dateToJS(accessToken.refreshDate),
            /*permissions: accessToken.grantedPermissions,*/
            "token": accessToken.authenticationToken,
            "userId": accessToken.userId
        ]
    }
    
    @objc func getCurrentAccessToken(_ call: CAPPluginCall) {
        guard let accessToken = AccessToken.current else {
            call.success()
            return
        }
        
        call.success([ "accessToken": accessTokenToJson(accessToken) ])
    }
}
