#import "FBSDKLoginHelper.h"
@import FBSDKLoginKit;
@import FBSDKCoreKit;

@implementation FBSDKLoginHelper

+ (void)loginFromViewController:(UIViewController *)viewController
                    permissions:(NSArray<NSString *> *)permissions
                trackingEnabled:(BOOL)trackingEnabled
                          nonce:(nullable NSString *)nonce
                     completion:(FBSDKLoginHelperResultBlock)completion {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    // Create configuration using Obj-C API
    FBSDKLoginConfiguration *configuration = nil;
    FBSDKLoginTracking tracking = trackingEnabled ? FBSDKLoginTrackingEnabled : FBSDKLoginTrackingLimited;
    
    if (nonce != nil && nonce.length > 0) {
        configuration = [[FBSDKLoginConfiguration alloc] initWithPermissions:permissions
                                                                    tracking:tracking
                                                                       nonce:nonce];
    } else {
        configuration = [[FBSDKLoginConfiguration alloc] initWithPermissions:permissions
                                                                    tracking:tracking];
    }
    
    if (configuration == nil) {
        if (completion) {
            completion(NO, NO, @"Invalid login configuration");
        }
        return;
    }
    
    [loginManager logInFromViewController:viewController
                            configuration:configuration
                               completion:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion(NO, NO, error.localizedDescription);
            }
            return;
        }
        
        if (result.isCancelled) {
            if (completion) {
                completion(NO, YES, nil);
            }
            return;
        }
        
        if (completion) {
            completion(YES, NO, nil);
        }
    }];
}

+ (void)reauthorizeDataAccessFromViewController:(UIViewController *)viewController
                                     completion:(FBSDKLoginHelperResultBlock)completion {
    
    // Check if we have a valid token that doesn't need reauth
    FBSDKAccessToken *currentToken = FBSDKAccessToken.currentAccessToken;
    if (currentToken != nil && !currentToken.isDataAccessExpired) {
        if (completion) {
            completion(YES, NO, nil);
        }
        return;
    }
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    [loginManager reauthorizeDataAccess:viewController
                                handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion(NO, NO, error.localizedDescription);
            }
            return;
        }
        
        if (result.isCancelled) {
            if (completion) {
                completion(NO, YES, nil);
            }
            return;
        }
        
        if (completion) {
            completion(YES, NO, nil);
        }
    }];
}

+ (void)logOut {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

+ (BOOL)hasCurrentAccessToken {
    return FBSDKAccessToken.currentAccessToken != nil || FBSDKAuthenticationToken.currentAuthenticationToken != nil;
}

+ (BOOL)isDataAccessExpired {
    FBSDKAccessToken *token = FBSDKAccessToken.currentAccessToken;
    if (token == nil) {
        // In limited login mode, only AuthenticationToken exists (no AccessToken)
        // Don't treat this as "expired" - return NO if we have an auth token
        return FBSDKAuthenticationToken.currentAuthenticationToken == nil;
    }
    return token.isDataAccessExpired;
}

+ (nullable NSString *)currentTokenString {
    FBSDKAuthenticationToken *authToken = FBSDKAuthenticationToken.currentAuthenticationToken;
    if (authToken != nil) {
        return authToken.tokenString;
    }
    
    FBSDKAccessToken *accessToken = FBSDKAccessToken.currentAccessToken;
    if (accessToken != nil) {
        return accessToken.tokenString;
    }
    
    return nil;
}

+ (nullable NSString *)currentUserID {
    FBSDKAccessToken *accessToken = FBSDKAccessToken.currentAccessToken;
    if (accessToken != nil) {
        return accessToken.userID;
    }
    return nil;
}

+ (BOOL)isAccessTokenExpired {
    FBSDKAccessToken *accessToken = FBSDKAccessToken.currentAccessToken;
    if (accessToken == nil) {
        // In limited login mode, only AuthenticationToken exists (no AccessToken)
        // Don't treat this as "expired" - return NO if we have an auth token
        return FBSDKAuthenticationToken.currentAuthenticationToken == nil;
    }
    return accessToken.isExpired;
}

+ (void)graphRequestWithPath:(NSString *)graphPath
                  parameters:(NSDictionary<NSString *, NSString *> *)parameters
                  completion:(FBSDKLoginHelperGraphResultBlock)completion {
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:graphPath
                                                                   parameters:parameters];
    
    [request startWithCompletion:^(id<FBSDKGraphRequestConnecting> _Nullable connection,
                                   id _Nullable result,
                                   NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion(nil, error.localizedDescription);
            }
            return;
        }
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (completion) {
                completion((NSDictionary *)result, nil);
            }
        } else {
            if (completion) {
                completion(nil, nil);
            }
        }
    }];
}

+ (void)logEventWithName:(NSString *)eventName {
    [FBSDKAppEvents.shared logEvent:eventName];
}

+ (void)setAutoLogAppEventsEnabled:(BOOL)enabled {
    FBSDKSettings.sharedSettings.isAutoLogAppEventsEnabled = enabled;
}

+ (void)setAdvertiserTrackingEnabled:(BOOL)enabled {
    FBSDKSettings.sharedSettings.isAdvertiserTrackingEnabled = enabled;
}

+ (void)setAdvertiserIDCollectionEnabled:(BOOL)enabled {
    FBSDKSettings.sharedSettings.isAdvertiserIDCollectionEnabled = enabled;
}

@end
