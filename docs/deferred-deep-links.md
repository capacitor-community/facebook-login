# Deferred App Links

Complete [Configuration](./configuration.md) before fetching a deferred App Link.

Deferred App Links associate a Meta ad click with the first launch after an app install. They are different from ordinary deep links that open an app which is already installed.

## Platform behavior

| Platform | Behavior                                                       |
| -------- | -------------------------------------------------------------- |
| Android  | Uses `AppLinkData.fetchDeferredAppLinkData`.                   |
| iOS      | Uses `AppLinkUtility.fetchDeferredAppLink` on the main thread. |
| Web      | Resolves without a URI.                                        |

Call the method after the native Facebook SDK has been configured:

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const { uri } = await FacebookLogin.getDeferredDeepLink();

if (uri) {
  // Route the user or send the attribution URI to your backend.
}
```

The promise resolves with an empty object when Meta has no deferred link for the install. Missing native configuration rejects the promise with a descriptive error. Native SDK errors are rejected when the platform exposes them; the Android SDK reports some request failures as an empty result.

The plugin makes one SDK request and does not retry a missing result. In particular, the iOS SDK only returns a deferred App Link once and records the first fetch for the install.

On Android, the plugin packages consumer R8 rules for the Google Play Services APIs that the Facebook SDK reads through reflection. Apps that already include the Google Advertising ID dependency keep those APIs intact in minified release builds.

## Testing

A regular custom-scheme or universal-link launch only tests ordinary deep-link routing; it does not create deferred attribution. To test the complete flow, use Meta's [App Ads Helper](https://developers.facebook.com/tools/app-ads-helper/) with an app you can access, uninstall the app before the test, trigger the deferred-link test, then install and launch the app once.

Automated plugin tests cover the URI, no-link, missing-configuration, and SDK-error outcomes without making a Meta network request. A real first-install attribution test still requires a configured Meta app and a fresh native install.
