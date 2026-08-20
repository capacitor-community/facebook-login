<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Facebook Login</h3>
<p align="center"><strong><code>@capacitor-community/facebook-login</code></strong></p>
<p align="center">
  Capacitor community plugin for native Facebook Login.
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2026?style=flat-square" />
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/l/@capacitor-community/facebook-login?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/dw/@capacitor-community/facebook-login?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/v/@capacitor-community/facebook-login?style=flat-square" /></a>
</p>

## Maintainers

| Maintainer          | GitHub                              | Social                                |
| ------------------- | ----------------------------------- | ------------------------------------- |
| Masahiko Sakakibara | [rdlabo](https://github.com/rdlabo) | [@rdlabo](https://twitter.com/rdlabo) |

Maintenance Status: Actively Maintained

## Contributors ✨

<a href="https://github.com/capacitor-community/facebook-login/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=capacitor-community/facebook-login" />
</a>

Made with [contributors-img](https://contrib.rocks).

## Demo

[Demo code is here.](./demo/angular)

## Overview

Capacitor community plugin for Facebook Login and Facebook App Events on
Android, iOS, and Web. It wraps the native Meta SDKs on Android and iOS and the
Facebook JavaScript SDK on Web.

## Features

- Facebook login and logout, with native data access reauthorization
- Current access token lookup
- Facebook Graph API profile requests
- Facebook App Events with string and number parameters
- Native App Event and advertiser settings

## Quick start

After [Installation](#installation) and the platform configuration below,
request the permissions your app needs:

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const result = await FacebookLogin.login({ permissions: ['email'] });

if (result.accessToken) {
  console.log('Facebook login completed.');
}
```

## Installation

This plugin targets Capacitor 8, iOS 15 or later, and Android API 24 or later.
It already includes the native Facebook SDK dependencies.

```bash
npm install @capacitor-community/facebook-login
npx cap sync
```

### Versions

Install the plugin major version that matches your Capacitor major version.

| Capacitor | Plugin |
| --------- | ------ |
| 8         | 8.x    |
| 7         | 7.x    |
| 6         | 6.x    |

For example, a Capacitor 7 application should install
`@capacitor-community/facebook-login@7`.

## Configuration

### Android configuration

In file `android/app/src/main/AndroidManifest.xml`, add the following XML elements under `<manifest><application>` :

```xml
<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
<meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token"/>
```

In file `android/app/src/main/res/values/strings.xml` add the following lines :

```xml
<string name="facebook_app_id">[APP_ID]</string>
<string name="facebook_client_token">[CLIENT_TOKEN]</string>
```

Don't forget to replace `[APP_ID]` and `[CLIENT_TOKEN]` by your Facebook application Id.

More information can be found here: https://developers.facebook.com/docs/android/getting-started

### Variables

This plugin will use the following project variables (defined in your app's `variables.gradle` file):

- `facebookSDKVersion`: version of `com.facebook.android:facebook-login` (default: `18.1.3`)

### iOS configuration

The plugin already includes `FBSDKCoreKit` and `FBSDKLoginKit`; do not add a
second Facebook SDK dependency. In `ios/App/App/AppDelegate.swift`, add or
replace the following:

```swift
import UIKit
import Capacitor
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        return true
    }

    ...

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Called when the app was launched with a url. Feel free to add additional processing here,
        // but if you want the App API to support tracking app url opens, make sure to keep this call
        if (FBSDKCoreKit.ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )) {
            return true;
        } else {
            return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
        }
    }
}
```

Add the following in the `ios/App/App/info.plist` file inside of the outermost `<dict>`:

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

More information can be found here: https://developers.facebook.com/docs/facebook-login/ios

### Web configuration

```typescript
import { FacebookLogin } from '@capacitor-community/facebook-login';

// use hook after platform dom ready
await FacebookLogin.initialize({ appId: '105890006170720' });
```

More information can be found here: https://developers.facebook.com/docs/facebook-login/web

## Platform support

| Method                                     | Android                     | iOS                         | Web                         |
| ------------------------------------------ | --------------------------- | --------------------------- | --------------------------- |
| `initialize`                               | No-op; configured natively  | No-op; configured natively  | Supported                   |
| `login`                                    | Supported                   | Limited Login by default    | Supported                   |
| `logout`                                   | Supported                   | Supported                   | Supported                   |
| `reauthorize`                              | Supported                   | Supported                   | Not implemented             |
| `getCurrentAccessToken`                    | Supported                   | Supported                   | Supported                   |
| `getProfile`                               | Supported                   | Requires a Graph token      | Supported                   |
| `logEvent`                                 | Supported                   | Supported                   | Supported                   |
| `setAutoLogAppEventsEnabled`               | Promise remains pending     | Supported                   | No-op                       |
| `setAdvertiserTrackingEnabled`             | Not implemented             | Supported                   | No-op                       |
| `setAdvertiserIDCollectionEnabled`         | Promise remains pending     | Supported                   | No-op                       |

`tracking` is an iOS-only login option and defaults to `limited`. In Limited
Login, iOS returns an OIDC authentication token (JWT), not a Graph API access
token. The plugin does not currently return the Graph access token obtained by
`tracking: 'enabled'`. `nonce` is used by the Android and iOS login flows and is
ignored on Web.

On Android, `setAutoLogAppEventsEnabled` and
`setAdvertiserIDCollectionEnabled` apply the requested value, but their
returned promises currently remain pending.

## Usage examples

### Login

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const FACEBOOK_PERMISSIONS = [
  'email',
  'user_birthday',
  'user_photos',
  'user_gender',
];
const result = await FacebookLogin.login({
  permissions: FACEBOOK_PERMISSIONS,
});

if (result.accessToken) {
  // Login successful.
  console.log(`Facebook token is ${result.accessToken.token}`);
} else {
  // No token was returned by the native platform.
}
```

### Logout

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

await FacebookLogin.logout();
```

### CurrentAccessToken

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const result = await FacebookLogin.getCurrentAccessToken();

if (result.accessToken) {
  console.log(`Facebook token is ${result.accessToken.token}`);
}
```

### getProfile

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const result = await FacebookLogin.getProfile<{
  email: string;
}>({ fields: ['email'] });

console.log(`Facebook user's email is ${result.email}`);
```

The requested fields must be permitted for your Meta app and granted by the
user. The returned object contains only fields returned by the Graph API. On
iOS, this requires a Graph access token and does not work with the default
Limited Login token.

### Reauthorize data access

Data access reauthorization is available on Android and iOS only.

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const result = await FacebookLogin.reauthorize();

if (result.accessToken) {
  console.log('Data access was renewed.');
}
```

### Log an App Event

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

await FacebookLogin.logEvent({
  eventName: 'completed_tutorial',
  parameters: {
    content_name: 'Getting Started',
    step: 3,
  },
});
```

Event parameter values must be strings or numbers.

### App Event and advertiser settings

These settings can be awaited on iOS. Request App Tracking Transparency
permission separately when needed.

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

await FacebookLogin.setAutoLogAppEventsEnabled({ enabled: true });
await FacebookLogin.setAdvertiserIDCollectionEnabled({ enabled: true });
await FacebookLogin.setAdvertiserTrackingEnabled({ enabled: true });
```

## API

<docgen-index>

* [`initialize(...)`](#initialize)
* [`login(...)`](#login)
* [`logout()`](#logout)
* [`reauthorize()`](#reauthorize)
* [`getCurrentAccessToken()`](#getcurrentaccesstoken)
* [`getProfile(...)`](#getprofile)
* [`logEvent(...)`](#logevent)
* [`setAutoLogAppEventsEnabled(...)`](#setautologappeventsenabled)
* [`setAdvertiserTrackingEnabled(...)`](#setadvertisertrackingenabled)
* [`setAdvertiserIDCollectionEnabled(...)`](#setadvertiseridcollectionenabled)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initialize(...)

```typescript
initialize(options: Partial<FacebookConfiguration>) => Promise<void>
```

Initializes the Facebook JavaScript SDK on Web.
This is a no-op on Android and iOS, where the SDK is configured natively.

| Param         | Type                                                                                                          |
| ------------- | ------------------------------------------------------------------------------------------------------------- |
| **`options`** | <code><a href="#partial">Partial</a>&lt;<a href="#facebookconfiguration">FacebookConfiguration</a>&gt;</code> |

--------------------


### login(...)

```typescript
login(options: { permissions: string[]; tracking?: 'limited' | 'enabled'; nonce?: string; }) => Promise<FacebookLoginResponse>
```

Starts the Facebook login flow with the requested permissions.
A cancelled native login resolves without a token.

| Param         | Type                                                                                       |
| ------------- | ------------------------------------------------------------------------------------------ |
| **`options`** | <code>{ permissions: string[]; tracking?: 'limited' \| 'enabled'; nonce?: string; }</code> |

**Returns:** <code>Promise&lt;<a href="#facebookloginresponse">FacebookLoginResponse</a>&gt;</code>

--------------------


### logout()

```typescript
logout() => Promise<void>
```

Logs out the current Facebook session.

--------------------


### reauthorize()

```typescript
reauthorize() => Promise<FacebookLoginResponse>
```

Requests renewed data access for the current Facebook session.

**Returns:** <code>Promise&lt;<a href="#facebookloginresponse">FacebookLoginResponse</a>&gt;</code>

--------------------


### getCurrentAccessToken()

```typescript
getCurrentAccessToken() => Promise<FacebookCurrentAccessTokenResponse>
```

Returns the current token. iOS returns an OIDC authentication token for
Limited Login. Native platforms resolve without a token when logged out;
Web rejects when there is no connected Facebook session.

**Returns:** <code>Promise&lt;<a href="#facebookcurrentaccesstokenresponse">FacebookCurrentAccessTokenResponse</a>&gt;</code>

--------------------


### getProfile(...)

```typescript
getProfile<T extends Record<string, unknown>>(options: { fields: readonly string[]; }) => Promise<T>
```

Requests the selected fields from the Facebook Graph API `/me` endpoint.

| Param         | Type                                        |
| ------------- | ------------------------------------------- |
| **`options`** | <code>{ fields: readonly string[]; }</code> |

**Returns:** <code>Promise&lt;T&gt;</code>

--------------------


### logEvent(...)

```typescript
logEvent(options: { eventName: string; parameters?: Record<string, string | number>; }) => Promise<void>
```

Logs a Facebook App Event with optional string or number parameters.

| Param         | Type                                                                                                           |
| ------------- | -------------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ eventName: string; parameters?: <a href="#record">Record</a>&lt;string, string \| number&gt;; }</code> |

--------------------


### setAutoLogAppEventsEnabled(...)

```typescript
setAutoLogAppEventsEnabled(options: { enabled: boolean; }) => Promise<void>
```

Enables or disables automatic App Event logging on native platforms.

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------


### setAdvertiserTrackingEnabled(...)

```typescript
setAdvertiserTrackingEnabled(options: { enabled: boolean; }) => Promise<void>
```

Enables or disables advertiser tracking on iOS.

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------


### setAdvertiserIDCollectionEnabled(...)

```typescript
setAdvertiserIDCollectionEnabled(options: { enabled: boolean; }) => Promise<void>
```

Enables or disables advertiser ID collection on native platforms.

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------


### Interfaces


#### FacebookConfiguration

| Prop                   | Type                 | Description                                                          |
| ---------------------- | -------------------- | -------------------------------------------------------------------- |
| **`appId`**            | <code>string</code>  | Meta application ID.                                                 |
| **`autoLogAppEvents`** | <code>boolean</code> | Whether the Web SDK automatically logs App Events.                   |
| **`xfbml`**            | <code>boolean</code> | Whether the Web SDK parses XFBML social plugins.                     |
| **`version`**          | <code>string</code>  | Facebook Graph API version used by the Web SDK. Defaults to `v17.0`. |
| **`locale`**           | <code>string</code>  | Locale used to load the Web SDK. Defaults to `en_US`.                |


#### FacebookLoginResponse

| Prop                             | Type                                                        | Description                                          |
| -------------------------------- | ----------------------------------------------------------- | ---------------------------------------------------- |
| **`accessToken`**                | <code><a href="#accesstoken">AccessToken</a> \| null</code> | Token response when one is returned by the platform. |
| **`recentlyGrantedPermissions`** | <code>string[]</code>                                       | Permissions granted during this login.               |
| **`recentlyDeniedPermissions`**  | <code>string[]</code>                                       | Permissions denied during this login.                |


#### AccessToken

| Prop                      | Type                  | Description                                                                                                                              |
| ------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **`applicationId`**       | <code>string</code>   | Meta application ID that issued the token.                                                                                               |
| **`declinedPermissions`** | <code>string[]</code> | Permissions declined by the user.                                                                                                        |
| **`expires`**             | <code>string</code>   | ISO 8601 token expiration date.                                                                                                          |
| **`isExpired`**           | <code>boolean</code>  | Whether the token is expired.                                                                                                            |
| **`lastRefresh`**         | <code>string</code>   | ISO 8601 date when the token was last refreshed.                                                                                         |
| **`permissions`**         | <code>string[]</code> | Permissions granted to the token.                                                                                                        |
| **`token`**               | <code>string</code>   | Token string returned by the platform. With iOS Limited Login, this is an OIDC authentication token (JWT), not a Graph API access token. |
| **`userId`**              | <code>string</code>   | Facebook user ID associated with the token.                                                                                              |


#### FacebookCurrentAccessTokenResponse

| Prop              | Type                                                        | Description                                                  |
| ----------------- | ----------------------------------------------------------- | ------------------------------------------------------------ |
| **`accessToken`** | <code><a href="#accesstoken">AccessToken</a> \| null</code> | Current token response when one is returned by the platform. |


### Type Aliases


#### Partial

Make all properties in T optional

<code>{ [P in keyof T]?: T[P]; }</code>


#### Record

Construct a type with a set of properties K of type T

<code>{ [P in K]: T; }</code>

</docgen-api>
