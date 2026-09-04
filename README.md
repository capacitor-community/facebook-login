<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Facebook Login</h3>
<p align="center"><strong><code>@capacitor-community/facebook-login</code></strong></p>
<p align="center">
  Capacitor community plugin for native Facebook Login.
</p>

<!-- rdlabo-docs-omit -->
<p align="center">
  <strong><a href="https://docs.rdlabo.dev/projects/capacitor-facebook-login">Read the full documentation</a></strong>
</p>
<!-- /rdlabo-docs-omit -->

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2026?style=flat-square" />
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/l/@capacitor-community/facebook-login?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/dw/@capacitor-community/facebook-login?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/facebook-login"><img src="https://img.shields.io/npm/v/@capacitor-community/facebook-login?style=flat-square" /></a>
</p>

## Maintainers

| Maintainer          | GitHub                              | Social                                | Website                               |
| ------------------- | ----------------------------------- | ------------------------------------- | ------------------------------------- |
| Masahiko Sakakibara | [rdlabo](https://github.com/rdlabo) | [@rdlabo](https://twitter.com/rdlabo) | [rdlabo.dev](https://rdlabo.dev/) |

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
- Deferred App Links for first-install attribution
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
It declares the native Facebook SDK dependencies for both CocoaPods and Swift
Package Manager.

```bash
npm install @capacitor-community/facebook-login
npx cap sync
```

Install the plugin major version that matches your Capacitor major version.

| Capacitor | Plugin |
| --------- | ------ |
| 8         | 8.x    |
| 7         | 7.x    |
| 6         | 6.x    |

Complete the required native and Web setup in
[Configuration](https://docs.rdlabo.dev/projects/capacitor-facebook-login/docs/configuration) before calling the plugin.

## Documentation

Start with [Configuration](https://docs.rdlabo.dev/projects/capacitor-facebook-login/docs/configuration), then use the guide for the
feature you are implementing. Method signatures and generated type information
remain in the [API](#api) section below.

- [Configuration](https://docs.rdlabo.dev/projects/capacitor-facebook-login/docs/configuration) — Meta app settings and Android, iOS,
  and Web SDK setup.
- [Authentication](https://docs.rdlabo.dev/projects/capacitor-facebook-login/docs/authentication) — login, logout, current tokens,
  profile fields, reauthorization, and platform differences.
- [App Events](https://docs.rdlabo.dev/projects/capacitor-facebook-login/docs/app-events) — custom events, parameters, automatic event
  logging, and advertiser settings.
- [Deferred App Links](https://docs.rdlabo.dev/projects/capacitor-facebook-login/docs/deferred-deep-links) — first-install attribution,
  platform behavior, and testing.

<!-- rdlabo-docs-omit -->

## Prerelease channels

An open, non-draft pull request can be published to the npm `beta` dist-tag after its `Validation` and `Package Candidate` workflows pass. A repository owner or maintainer must add a comment whose entire body is:

```text
/beta
```

The request authorizes only the pull request head SHA that existed when the comment was added. The workflow revalidates the owner or maintainer permission and head SHA immediately before publishing. Any new commit requires CI to pass again and a fresh owner or maintainer `/beta` comment. Fork pull requests are supported. Pull requests that change a release-gating workflow cannot be beta-published until those workflow changes land on `main`.

Beta versions use `<base>-beta.pr<PR number>.sha<12-character SHA>`. The candidate is built in a read-only workflow without npm publishing credentials. The privileged release workflow publishes only the validated immutable package artifact with lifecycle scripts disabled. A notification failure cannot invalidate a successful npm publish.

When a pull request is merged into `main`, it is automatically published to `beta` only after the required CI and `Package Candidate` succeed for that exact merge commit. Direct pushes to `main` do not publish a candidate.

Only `npm run release` creates a release tag. Stable `vX.Y.Z` tags publish to npm `latest`; revision/prerelease tags publish to `next`. Neither `beta` nor `next` publishing changes the npm `latest` dist-tag.

<!-- /rdlabo-docs-omit -->

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
* [`getDeferredDeepLink()`](#getdeferreddeeplink)
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


### getDeferredDeepLink()

```typescript
getDeferredDeepLink() => Promise<FacebookDeferredDeepLinkResponse>
```

Fetches the deferred App Link attributed to this app install.
Android retries missing attribution data five times before rejecting. iOS
and Web resolve without a URI when no link is available.

**Returns:** <code>Promise&lt;<a href="#facebookdeferreddeeplinkresponse">FacebookDeferredDeepLinkResponse</a>&gt;</code>

--------------------


### Interfaces


#### FacebookConfiguration

| Prop                   | Type                 | Description                                                          |
| ---------------------- | -------------------- | -------------------------------------------------------------------- |
| **`appId`**            | <code>string</code>  | Meta application ID.                                                 |
| **`autoLogAppEvents`** | <code>boolean</code> | Whether the Web SDK automatically logs App Events.                   |
| **`xfbml`**            | <code>boolean</code> | Whether the Web SDK parses XFBML social plugins.                     |
| **`version`**          | <code>string</code>  | Facebook Graph API version used by the Web SDK. Defaults to `v26.0`. |
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


#### FacebookDeferredDeepLinkResponse

| Prop                | Type                                                             | Description                                                            |
| ------------------- | ---------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **`uri`**           | <code>string</code>                                              | Deferred App Link URI. Omitted when Meta has no link for this install. |
| **`promotionCode`** | <code>string</code>                                              | Promotion code returned by the Android SDK, when present.              |
| **`arguments`**     | <code><a href="#record">Record</a>&lt;string, unknown&gt;</code> | Deferred App Link argument bundle returned by the Android SDK.         |


### Type Aliases


#### Partial

Make all properties in T optional

<code>{ [P in keyof T]?: T[P]; }</code>


#### Record

Construct a type with a set of properties K of type T

<code>{ [P in K]: T; }</code>

</docgen-api>
