# Authentication

Complete [Configuration](./configuration.md) before using the authentication methods.

## Platform behavior

| Method                  | Android   | iOS                      | Web             |
| ----------------------- | --------- | ------------------------ | --------------- |
| `login`                 | Supported | Limited Login by default | Supported       |
| `logout`                | Supported | Supported                | Supported       |
| `reauthorize`           | Supported | Supported                | Not implemented |
| `getCurrentAccessToken` | Supported | Limited Login token      | Supported       |
| `getProfile`            | Supported | Requires a Graph token   | Supported       |

The `tracking` login option is iOS-only and defaults to `limited`. In Limited Login, iOS returns an OIDC authentication token (JWT), not a Graph API access token. The plugin does not currently return the Graph access token obtained with `tracking: 'enabled'`.

The `nonce` option is used by Android and iOS and ignored on Web. Pass the raw nonce; the native implementations hash it before giving it to the Facebook SDK.

## Login

Request only the permissions your app uses:

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

const result = await FacebookLogin.login({
  permissions: ['email', 'user_birthday'],
});

if (result.accessToken) {
  console.log(`Facebook token: ${result.accessToken.token}`);
} else {
  // No token was returned by the native platform.
}
```

On Web, login rejects if Facebook does not return a usable token. On Android and iOS, a cancelled login resolves without a token.

### iOS tracking mode and nonce

```ts
const result = await FacebookLogin.login({
  permissions: ['email'],
  tracking: 'limited',
  nonce: crypto.randomUUID(),
});
```

Limited Login tokens should be validated as OIDC tokens by your backend. Do not treat them as Graph API access tokens.

## Current token

```ts
const result = await FacebookLogin.getCurrentAccessToken();

if (result.accessToken) {
  console.log(`Current Facebook token: ${result.accessToken.token}`);
}
```

Native platforms resolve without a token when logged out. Web rejects when there is no connected Facebook session.

## Profile fields

```ts
const profile = await FacebookLogin.getProfile<{
  id: string;
  email?: string;
}>({ fields: ['id', 'email'] });
```

The fields must be permitted for your Meta app and granted by the user. The returned object contains only fields returned by the Graph API. On iOS, this requires a Graph access token and does not work with the default Limited Login token.

## Reauthorize data access

Reauthorization is available on Android and iOS only.

```ts
const result = await FacebookLogin.reauthorize();

if (result.accessToken) {
  console.log('Data access was renewed.');
}
```

## Logout

```ts
await FacebookLogin.logout();
```

Logging out clears the Facebook session managed by the platform SDK.
