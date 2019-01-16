declare global {
  interface PluginRegistry {
    FacebookLogin?: FacebookLoginPlugin;
  }
}

export interface AccessToken {
  applicationId: string;
  declinedPermissions: string[];
  expires: string;
  isExpired: boolean;
  lastRefresh: string;
  permissions: string[];
  token: string;
  userId: string;
}

export interface FacebookLoginResponse {
  status: 'connected' | 'authorization_expired' | 'not_authorized' | string;
  authResponse: {
    accessToken: string;
    data_access_expiration_time: number;
    expiresIn: number;
    reauthorize_required_in: number;
    signedRequest: number;
    userID: number;
  }
  recentlyGrantedPermissions: string[];
  recentlyDeniedPermissions: string[];
}

export interface FacebookCurrentAccessTokenResponse {
  accessToken: AccessToken | null;
}

export interface FacebookLoginPlugin {
  login(options: { permissions: string[] }): Promise<FacebookLoginResponse>;
  logout(): Promise<void>;
  getCurrentAccessToken(): Promise<FacebookCurrentAccessTokenResponse>;
}
