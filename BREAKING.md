# Breaking Changes
## 1.1.0
### Description
- Update using SDK
- FacebookCore 0.5.0 => 0.9.0
- FacebookLogin 0.5.0 => 0.9.0

### Migrating
#### iOS

__ios/App/App/AppDelegate.swift__
```diff
  import FacebookCore
+ import FacebookCore
+ import FBSDKCoreKit

- SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
+ FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

- return SDKApplicationDelegate.shared.application(app, open: url, options: options)
+ return FBSDKCoreKit.ApplicationDelegate.shared.application(app, open: url, options: options)
```

