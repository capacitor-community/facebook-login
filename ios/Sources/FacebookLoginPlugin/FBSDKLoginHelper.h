#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Result block for login operations
typedef void (^FBSDKLoginHelperResultBlock)(BOOL success, BOOL cancelled, NSString * _Nullable errorMessage);

/// Result block for graph requests
typedef void (^FBSDKLoginHelperGraphResultBlock)(NSDictionary * _Nullable result, NSString * _Nullable errorMessage);

/// Objective-C helper to bridge FBSDK calls, avoiding Swift API gating issues with NonescapableTypes
@interface FBSDKLoginHelper : NSObject

/// Perform Facebook login with configuration
/// @param viewController The view controller to present from
/// @param permissions Array of permission strings
/// @param trackingEnabled YES for .enabled tracking, NO for .limited
/// @param nonce Optional nonce string (pass nil or empty to skip)
/// @param completion Completion block with success/cancelled/error info
+ (void)loginFromViewController:(UIViewController *)viewController
                    permissions:(NSArray<NSString *> *)permissions
                trackingEnabled:(BOOL)trackingEnabled
                          nonce:(nullable NSString *)nonce
                     completion:(FBSDKLoginHelperResultBlock)completion;

/// Perform reauthorization for data access
/// @param viewController The view controller to present from
/// @param completion Completion block
+ (void)reauthorizeDataAccessFromViewController:(UIViewController *)viewController
                                     completion:(FBSDKLoginHelperResultBlock)completion;

/// Log out the current user
+ (void)logOut;

/// Check if there's a current access token
+ (BOOL)hasCurrentAccessToken;

/// Check if the current access token's data access is expired
+ (BOOL)isDataAccessExpired;

/// Get current access token string (from AccessToken or AuthenticationToken)
+ (nullable NSString *)currentTokenString;

/// Get current user ID from access token
+ (nullable NSString *)currentUserID;

/// Check if current access token is expired
+ (BOOL)isAccessTokenExpired;

/// Perform a Graph API request
/// @param graphPath The graph path (e.g., "me")
/// @param parameters Request parameters
/// @param completion Completion block with result dictionary or error
+ (void)graphRequestWithPath:(NSString *)graphPath
                  parameters:(NSDictionary<NSString *, NSString *> *)parameters
                  completion:(FBSDKLoginHelperGraphResultBlock)completion;

/// Log an app event
/// @param eventName The event name to log
+ (void)logEventWithName:(NSString *)eventName;

/// Set auto log app events enabled
/// @param enabled Whether to enable auto logging
+ (void)setAutoLogAppEventsEnabled:(BOOL)enabled;

/// Set advertiser tracking enabled
/// @param enabled Whether to enable advertiser tracking
+ (void)setAdvertiserTrackingEnabled:(BOOL)enabled;

/// Set advertiser ID collection enabled
/// @param enabled Whether to enable advertiser ID collection
+ (void)setAdvertiserIDCollectionEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
