export interface AccessToken {
  /** Meta application ID that issued the token. */
  applicationId?: string;
  /** Permissions declined by the user. */
  declinedPermissions?: string[];
  /** ISO 8601 token expiration date. */
  expires?: string;
  /** Whether the token is expired. */
  isExpired?: boolean;
  /** ISO 8601 date when the token was last refreshed. */
  lastRefresh?: string;
  /** Permissions granted to the token. */
  permissions?: string[];
  /**
   * Token string returned by the platform. With iOS Limited Login, this is an
   * OIDC authentication token (JWT), not a Graph API access token.
   */
  token: string;
  /** Facebook user ID associated with the token. */
  userId?: string;
}

export interface FacebookLoginResponse {
  /** Token response when one is returned by the platform. */
  accessToken: AccessToken | null;
  /** Permissions granted during this login. */
  recentlyGrantedPermissions?: string[];
  /** Permissions denied during this login. */
  recentlyDeniedPermissions?: string[];
}

export interface FacebookCurrentAccessTokenResponse {
  /** Current token response when one is returned by the platform. */
  accessToken: AccessToken | null;
}

export interface FacebookDeferredDeepLinkResponse {
  /** Deferred App Link URI. Omitted when Meta has no link for this install. */
  uri?: string;
}

export interface FacebookLoginPlugin {
  /**
   * Initializes the Facebook JavaScript SDK on Web.
   * This is a no-op on Android and iOS, where the SDK is configured natively.
   */
  initialize(options: Partial<FacebookConfiguration>): Promise<void>;
  /**
   * Starts the Facebook login flow with the requested permissions.
   * A cancelled native login resolves without a token.
   */
  login(options: {
    /** Facebook permissions to request. */
    permissions: string[];
    /**
     * Limited Login: iOS Only.
     * https://developers.facebook.com/docs/facebook-login/limited-login/ios/
     */
    tracking?: 'limited' | 'enabled';
    /**
     * A random string used to verify the identity of the person who is logging in.
     * This requires raw string, not sha256 hash.
     */
    nonce?: string;
  }): Promise<FacebookLoginResponse>;
  /** Logs out the current Facebook session. */
  logout(): Promise<void>;
  /** Requests renewed data access for the current Facebook session. */
  reauthorize(): Promise<FacebookLoginResponse>;
  /**
   * Returns the current token. iOS returns an OIDC authentication token for
   * Limited Login. Native platforms resolve without a token when logged out;
   * Web rejects when there is no connected Facebook session.
   */
  getCurrentAccessToken(): Promise<FacebookCurrentAccessTokenResponse>;
  /** Requests the selected fields from the Facebook Graph API `/me` endpoint. */
  getProfile<T extends Record<string, unknown>>(options: { fields: readonly string[] }): Promise<T>;
  /** Logs a Facebook App Event with optional string or number parameters. */
  logEvent(options: { eventName: string; parameters?: Record<string, string | number> }): Promise<void>;
  /** Enables or disables automatic App Event logging on native platforms. */
  setAutoLogAppEventsEnabled(options: { enabled: boolean }): Promise<void>;
  /** Enables or disables advertiser tracking on iOS. */
  setAdvertiserTrackingEnabled(options: { enabled: boolean }): Promise<void>;
  /** Enables or disables advertiser ID collection on native platforms. */
  setAdvertiserIDCollectionEnabled(options: { enabled: boolean }): Promise<void>;
  /**
   * Fetches the deferred App Link attributed to this app install.
   * Native platforms resolve without a URI when no link is available. Web
   * always resolves without a URI.
   */
  getDeferredDeepLink(): Promise<FacebookDeferredDeepLinkResponse>;
}

export interface FacebookGetLoginStatusResponse {
  status: 'connected';
  authResponse: {
    accessToken: string;
    expiresIn: number;
    reauthorize_required_in: number;
    signedRequest: string;
    userID: string;
  };
}

export interface FacebookError {
  message: string;
  type: string;
  code: number;
}

export interface FacebookGetProfileResponse {
  error: FacebookError | null;
}

export interface FacebookConfiguration {
  /** Meta application ID. */
  appId: string;
  /** Whether the Web SDK automatically logs App Events. */
  autoLogAppEvents: boolean;
  /** Whether the Web SDK parses XFBML social plugins. */
  xfbml: boolean;
  /** Facebook Graph API version used by the Web SDK. Defaults to `v26.0`. */
  version: string;
  /** Locale used to load the Web SDK. Defaults to `en_US`. */
  locale: string;
}
