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
  accessToken: AccessToken | null;
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
