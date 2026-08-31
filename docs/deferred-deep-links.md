# Deferred App Links

Complete [Configuration](./configuration.md) before fetching a deferred App Link.

Deferred App Links associate a Meta ad click with the first launch after an app install. They are different from ordinary deep links that open an app which is already installed.

## Platform behavior

| Platform | Behavior                                                                                                      |
| -------- | ------------------------------------------------------------------------------------------------------------- |
| Android  | Initializes the SDK, then uses `AppLinkData.fetchDeferredAppLinkData`; retries missing data five times.       |
| iOS      | Initializes the SDK when the plugin loads, then uses `AppLinkUtility.fetchDeferredAppLink` on the main thread. |
| Web      | Resolves without a URI.                                                                                       |

Call the method after the native Facebook SDK has been configured:

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const { uri } = await FacebookLogin.getDeferredDeepLink();

if (uri) {
  // Route the user or send the attribution URI to your backend.
}
```

Android responses can also contain `promotionCode` and `arguments` when Meta includes them. iOS and Web resolve without a URI when no deferred link exists. Missing iOS configuration and native SDK errors reject with a descriptive error.

Android preserves the plugin's established attribution timing: one initial request followed by up to five retries at two-second intervals. It rejects if every attempt returns no data. iOS makes one request because its SDK only returns a deferred App Link once and records the first fetch for the install.

On Android, the plugin packages consumer R8 rules for the Google Play Services APIs that the Facebook SDK reads through reflection. Apps that already include the Google Advertising ID dependency keep those APIs intact in minified release builds.

## Testing

A regular custom-scheme or universal-link launch only tests ordinary deep-link routing; it does not create deferred attribution. To test the complete flow, use Meta's [App Ads Helper](https://developers.facebook.com/tools/app-ads-helper/) with an app you can access, uninstall the app before the test, trigger the deferred-link test, then install and launch the app once.

Automated plugin tests cover the Android payload and retry contract plus the iOS URI, no-link, missing-configuration, and SDK-error outcomes without making a Meta network request. A real first-install attribution test still requires a configured Meta app and a fresh native install.
