# capacitor-facebook-login
Facebook Login plugin for Capacitor

## Installation

```bash
npm i --save @oxylian/capacitor-facebook-login
```

## Android configuration

In file `MainActivity.java`, add the plugin to the initialization list:

```java
this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
  [...]
  add(com.oxylian.capacitor.plugin.facebook.FacebookLogin.class);
  [...]
}});
```

In file `AndroidManifest.xml`, add the following XML elements in `//manifest/application` :

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

In file `res/values/strings.xml` add the following lines :

```
<string name="facebook_app_id">[APP_ID]</string>
<string name="fb_login_protocol_scheme">fb[APP_ID]</string>
```

Don't forget to replace `[APP_ID]` by your Facebook application Id.

More information can be found here: https://developers.facebook.com/docs/facebook-login/android

## iOS configuration

In file `AppDelegate.swift` add or replace the following:

```
import FacebookCore
[...]
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
  if CAPBridge.handleOpenUrl(url, options) {
    return true;
  }
    
  return SDKApplicationDelegate.shared.application(app, open: url, options: options)
}
```

Add the following in the `info.plist` file:

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
  <string>fbauth2</string>
</array>
```

More information can be found here: https://developers.facebook.com/docs/facebook-login/ios

## Web configuration

```js
window.fbAsyncInit = function() {
  FB.init({
    appId: '[APP_ID]',
    cookie: true, // enable cookies to allow the server to access the session
    xfbml: true, // parse social plugins on this page
    version: 'v2.8' // use graph api version 2.8
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

## API

### Login

```js
const FACEBOOK_PERMISSIONS = ['email', 'user_birthday', 'user_photos', 'user_gender'];

const result = await Plugins.FacebookLogin.login({ permissions: FACEBOOK_PERMISSIONS });

if (result.accessToken) {
  // Login successful.
  console.log(`Facebook access token is ${result.accessToken.token}`);
} else {
  // Cancelled by user.
}
```

### Logout

```js
await Plugins.FacebookLogin.logout();
```

### CurrentAccessToken

```js
const result = await Plugins.FacebookLogin.getCurrentAccessToken();

if (result.accessToken) {
  console.log(`Facebook access token is ${result.accessToken.token}`);
} else {
  // Not logged in.
}
```
