# test

test

## Install

```bash
npm install @capacitor-community/facebook-login
npx cap sync
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
