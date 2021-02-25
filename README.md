[![npm version](https://badge.fury.io/js/%40capacitor-community%2Ffacebook-login.svg)](https://badge.fury.io/js/%40capacitor-community%2Ffacebook-login)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

__Please check [branch 'feat/v3'](https://github.com/capacitor-community/facebook-login/tree/feature/v3), if you want use capacitor v3@beta__

# capacitor-facebook-login
Capacitory community plugin for Facebook Login.

## Demo
[Demo code is here.](https://github.com/capacitor-community/facebook-login/tree/master/demo/angular)

## Maintainers

| Maintainer | GitHub  | Social | Sponsoring Company |
| --- | --- | --- | --- |
| Masahiko Sakakibara  | [rdlabo](https://github.com/rdlabo)  | [@rdlabo](https://twitter.com/rdlabo) | RELATION DESIGN LABO, GENERAL INC. ASSOCIATION |
 
Mainteinance Status: Actively Maintained

## Installation

```bash
% npm i --save @capacitor-community/facebook-login
% npx cap update
```

To use yarn

```bash
% yarn add @capacitor-community/facebook-login
% npx cap update
```

### If you use Capacitor 1.x
```
% npm install --save @rdlabo/capacitor-facebook-login@1.5.0
% npx cap update
```

## Android configuration

In file `android/app/src/main/java/**/**/MainActivity.java`, add the plugin to the initialization list:

```java
this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
  [...]
  add(com.getcapacitor.community.facebooklogin.FacebookLogin.class);
  [...]
}});
```

In file `android/app/src/main/AndroidManifest.xml`, add the following XML elements under `<manifest><application>` :

```xml
<meta-data android:name="com.facebook.sdk.ApplicationId"
  android:value="@string/facebook_app_id"/>

<activity
    android:name="com.facebook.FacebookActivity"
    android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
    android:label="@string/app_name" />

<activity
    android:name="com.facebook.CustomTabActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="@string/fb_login_protocol_scheme" />
    </intent-filter>
</activity>
```

In file `android/app/src/main/res/values/strings.xml` add the following lines :

```xml
<string name="facebook_app_id">[APP_ID]</string>
<string name="fb_login_protocol_scheme">fb[APP_ID]</string>
```

Don't forget to replace `[APP_ID]` by your Facebook application Id.

More information can be found here: https://developers.facebook.com/docs/facebook-login/android

### If you have trouble.
Please restart Android Studio, and do clean build.

## iOS configuration

In file `ios/App/App/AppDelegate.swift` add or replace the following:

```swift
import FBSDKCoreKit
import FBSDKCoreKit
  [...]
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if CAPBridge.handleOpenUrl(url, options) {
        return FBSDKCoreKit.ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    else{
     return false
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
<key>FacebookDisplayName</key>
<string>Wimlov</string>
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

## Web configuration

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

```ts
  // Init Capacitor
import { registerWebPlugin } from '@capacitor/core';
import { FacebookLogin } from '@capacitor-community/facebook-login';
  ...
registerWebPlugin(FacebookLogin);
```

More information can be found here: https://developers.facebook.com/docs/facebook-login/web
And you must confirm return type at https://github.com/rdlabo/capacitor-facebook-login/blob/master/src/web.ts#L55-L57
not same type for default web facebook login!


## Supported methods

| Name                  | Android | iOS | Web |
| :-------------------- | :------ | :-- | :-- |
| login                 | ✅      | ✅  | ✅ |
| logout                | ✅      | ✅  | ✅  |
| getCurrentAccessToken | ✅      | ✅  | ✅  |
| getProfile            | ✅      | ✅  | ✅  |

## API

### Login

```ts
import { Plugins } from '@capacitor/core';
import { FacebookLoginResponse } from '@capacitor-community/facebook-login';
const { FacebookLogin } = Plugins;

const FACEBOOK_PERMISSIONS = ['email', 'user_birthday', 'user_photos', 'user_gender'];
const result = await <FacebookLoginResponse>FacebookLogin.login({ permissions: FACEBOOK_PERMISSIONS });

if (result.accessToken) {
  // Login successful.
  console.log(`Facebook access token is ${result.accessToken.token}`);
} else {
  // Cancelled by user.
}
```

### Logout

```ts
import { Plugins } from '@capacitor/core';
const { FacebookLogin } = Plugins;

await FacebookLogin.logout();
```

### CurrentAccessToken

```ts
import { Plugins } from '@capacitor/core';
import { FacebookLoginResponse } from '@capacitor-community/facebook-login';
const { FacebookLogin } = Plugins;

const result = await <FacebookLoginResponse>FacebookLogin.getCurrentAccessToken();

if (result.accessToken) {
  console.log(`Facebook access token is ${result.accessToken.token}`);
} else {
  // Not logged in.
}
```

### getProfile

```ts
import { Plugins } from '@capacitor/core';
import { FacebookLoginResponse } from '@capacitor-community/facebook-login';
const { FacebookLogin } = Plugins;

const result = await FacebookLogin.getProfile<{
      email: string;
    }>({ fields: ['email'] });

console.log(`Facebook user's email is ${result.email}`);
```

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
