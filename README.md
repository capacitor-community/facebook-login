<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Facebook Login</h3>
<p align="center"><strong><code>@capacitor-community/facebook-login</code></strong></p>
<p align="center">
  Capacitor community plugin for native Facebook Login.
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2021?style=flat-square" />
  <!-- <a href="https://github.com/capacitor-community/example/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/capacitor-community/example/CI?style=flat-square" /></a> -->
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/l/@capacitor-community/facebook-login?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/dw/@capacitor-community/facebook-login?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/v/@capacitor-community/facebook-login?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-2-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Maintainers

| Maintainer | GitHub  | Social | Sponsoring Company |
| --- | --- | --- | --- |
| Masahiko Sakakibara  | [rdlabo](https://github.com/rdlabo)  | [@rdlabo](https://twitter.com/rdlabo) | RELATION DESIGN LABO, GENERAL INC. ASSOCIATION |

Mainteinance Status: Actively Maintained

## Demo
[Demo code is here.](https://github.com/capacitor-community/facebook-login/tree/master/demo/angular)

## Installation

```bash
% npm i --save @capacitor-community/facebook-login
% npx cap update
```

### Android configuration

In file `android/app/src/main/java/**/**/MainActivity.java`, add the plugin to the initialization list:

```java
public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        registerPlugin(com.getcapacitor.community.facebooklogin.FacebookLogin.class);
    }
}
```

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

#### If you have trouble.
Please restart Android Studio, and do clean build.

### iOS configuration

In file `ios/App/App/AppDelegate.swift` add or replace the following:

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

```javascript
window.fbAsyncInit = function() {
  FB.init({
    appId: '[APP_ID]',
    cookie: true, // enable cookies to allow the server to access the session
    xfbml: true, // parse social plugins on this page
    version: 'v5.0' // use graph api current version
  });
};

// Load the SDK asynchronously
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "https://connect.facebook.net/en_US/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
```

More information can be found here: https://developers.facebook.com/docs/facebook-login/web
And you must confirm return type at https://github.com/rdlabo/capacitor-facebook-login/blob/master/src/web.ts#L55-L57
not same type for default web facebook login!

## Example

### Login

```ts
import { FacebookLogin, FacebookLoginResponse } from '@capacitor-community/facebook-login';

const FACEBOOK_PERMISSIONS = ['email', 'user_birthday', 'user_photos', 'user_gender'];
const result = await <FacebookLoginResponse>FacebookLogin.login({ permissions: FACEBOOK_PERMISSIONS });

if (result.accessToken) {
  // Login successful.
  console.log(`Facebook access token is ${result.accessToken.token}`);
}
```

### Logout

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

await FacebookLogin.logout();
```

### CurrentAccessToken

```ts
import { FacebookLogin, FacebookLoginResponse } from '@capacitor-community/facebook-login';

const result = await <FacebookLoginResponse>FacebookLogin.getCurrentAccessToken();

if (result.accessToken) {
  console.log(`Facebook access token is ${result.accessToken.token}`);
}
```

### getProfile

```ts
import { FacebookLogin, FacebookLoginResponse } from '@capacitor-community/facebook-login';

const result = await FacebookLogin.getProfile<{
      email: string;
    }>({ fields: ['email'] });

console.log(`Facebook user's email is ${result.email}`);
```

## API

<docgen-index>

* [`login(...)`](#login)
* [`logout()`](#logout)
* [`getCurrentAccessToken()`](#getcurrentaccesstoken)
* [`getProfile(...)`](#getprofile)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### login(...)

```typescript
login(options: { permissions: string[]; }) => Promise<FacebookLoginResponse>
```

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ permissions: string[]; }</code> |

**Returns:** <code>Promise&lt;<a href="#facebookloginresponse">FacebookLoginResponse</a>&gt;</code>

--------------------


### logout()

```typescript
logout() => Promise<void>
```

--------------------


### getCurrentAccessToken()

```typescript
getCurrentAccessToken() => Promise<FacebookCurrentAccessTokenResponse>
```

**Returns:** <code>Promise&lt;<a href="#facebookcurrentaccesstokenresponse">FacebookCurrentAccessTokenResponse</a>&gt;</code>

--------------------


### getProfile(...)

```typescript
getProfile<T extends object>(options: { fields: readonly string[]; }) => Promise<T>
```

| Param         | Type                                        |
| ------------- | ------------------------------------------- |
| **`options`** | <code>{ fields: readonly string[]; }</code> |

**Returns:** <code>Promise&lt;T&gt;</code>

--------------------


### Interfaces


#### FacebookLoginResponse

| Prop                             | Type                                                        |
| -------------------------------- | ----------------------------------------------------------- |
| **`accessToken`**                | <code><a href="#accesstoken">AccessToken</a> \| null</code> |
| **`recentlyGrantedPermissions`** | <code>string[]</code>                                       |
| **`recentlyDeniedPermissions`**  | <code>string[]</code>                                       |


#### AccessToken

| Prop                      | Type                  |
| ------------------------- | --------------------- |
| **`applicationId`**       | <code>string</code>   |
| **`declinedPermissions`** | <code>string[]</code> |
| **`expires`**             | <code>string</code>   |
| **`isExpired`**           | <code>boolean</code>  |
| **`lastRefresh`**         | <code>string</code>   |
| **`permissions`**         | <code>string[]</code> |
| **`token`**               | <code>string</code>   |
| **`userId`**              | <code>string</code>   |


#### FacebookCurrentAccessTokenResponse

| Prop              | Type                                                        |
| ----------------- | ----------------------------------------------------------- |
| **`accessToken`** | <code><a href="#accesstoken">AccessToken</a> \| null</code> |

</docgen-api>

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://www.mapianist.com"><img src="https://avatars.githubusercontent.com/u/7777929?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Heo</b></sub></a><br /><a href="https://github.com/capacitor-community/facebook-login/commits?author=leo6104" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/vildhjarta8"><img src="https://avatars.githubusercontent.com/u/2393640?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Artur Tiupa</b></sub></a><br /><a href="https://github.com/capacitor-community/facebook-login/commits?author=vildhjarta8" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
