# Configuration

Create or select an app in the [Meta App Dashboard](https://developers.facebook.com/apps/), enable Facebook Login, and configure each platform that your Capacitor app supports.

The plugin targets Capacitor 8, iOS 15 or later, and Android API 24 or later. It declares the native Facebook SDK dependencies, so do not add a second Facebook SDK dependency.

## Android

In `android/app/src/main/AndroidManifest.xml`, add the following inside `<application>`:

```xml
<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id" />
<meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token" />
```

In `android/app/src/main/res/values/strings.xml`:

```xml
<string name="facebook_app_id">[APP_ID]</string>
<string name="facebook_client_token">[CLIENT_TOKEN]</string>
```

Replace `[APP_ID]` and `[CLIENT_TOKEN]` with values from your Meta app. Add your Android package name, activity class, and release/debug key hashes in the Meta App Dashboard. See Meta's [Android getting started guide](https://developers.facebook.com/docs/android/getting-started).

### Android variables

Override the following in your app's `variables.gradle` only when you need a specific SDK version:

| Variable             | Artifacts                                                                       | Default  |
| -------------------- | ------------------------------------------------------------------------------- | -------- |
| `facebookSDKVersion` | `com.facebook.android:facebook-login`, `com.facebook.android:facebook-applinks` | `18.3.0` |

## iOS

The plugin declares `FBSDKCoreKit` and `FBSDKLoginKit` as dependencies for CocoaPods and Swift Package Manager. Do not add the Facebook iOS SDK separately.

The CocoaPods dependencies use `~> 18.1`, and Swift Package Manager resolves
from `18.1.0` up to the next major version.

In `ios/App/App/AppDelegate.swift`, initialize the SDK and forward the login callback URL:

```swift
import UIKit
import Capacitor
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[.sourceApplication] as? String,
            annotation: options[.annotation]
        ) {
            return true
        }
        return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
    }
}
```

Add the following inside the outermost `<dict>` in `ios/App/App/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb[APP_ID]</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>[APP_ID]</string>
<key>FacebookClientToken</key>
<string>[CLIENT_TOKEN]</string>
<key>FacebookDisplayName</key>
<string>[APP_NAME]</string>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fbapi20130214</string>
  <string>fbapi20130410</string>
  <string>fbapi20130702</string>
  <string>fbapi20131010</string>
  <string>fbapi20131219</string>
  <string>fbapi20140410</string>
  <string>fbapi20140116</string>
  <string>fbapi20150313</string>
  <string>fbapi20150629</string>
  <string>fbapi20160328</string>
  <string>fbauth</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```

Replace all placeholders with values from your Meta app. Add the bundle ID to the iOS platform in the Meta App Dashboard. See Meta's [iOS login guide](https://developers.facebook.com/docs/facebook-login/ios).

## Web

Initialize the Facebook JavaScript SDK after the DOM is available and before calling other plugin methods:

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

await FacebookLogin.initialize({
  appId: '[APP_ID]',
  locale: 'en_US',
});
```

`initialize` is a no-op on Android and iOS because those SDKs are configured natively. Web defaults to Graph API `v26.0` and locale `en_US` when those options are omitted. See Meta's [Web login guide](https://developers.facebook.com/docs/facebook-login/web).

## Next steps

- [Authentication](./authentication.md)
- [App Events](./app-events.md)
- [Deferred App Links](./deferred-deep-links.md)
