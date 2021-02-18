import { WebPlugin } from '@capacitor/core';
import {
  FacebookLoginPlugin,
  FacebookLoginResponse,
  FacebookCurrentAccessTokenResponse, FacebookGetLoginStatusResponse, FacebookGetProfileResponse,
} from './definitions';

declare interface Facebook {
  init(options: {
    appId: string;
    autoLogAppEvents: boolean;
    xfbml: boolean;
    version: string;
  }): void;

  login(handle: (response: any) => void, options?: { scope: string }): void;

  logout(handle: (response: any) => void): void;

  getLoginStatus(
    handle: (response: FacebookGetLoginStatusResponse) => void,
  ): void;

  api<TResponse>(path: string, callback: (response: TResponse) => void): void;
  api<TParams extends object, TResponse>(
    path: string,
    params: TParams,
    callback: (response: TResponse) => void,
  ): void;
  api<TParams extends object, TResponse>(
    path: string,
    method: 'get' | 'post' | 'delete',
    params: TParams,
    callback: (response: TResponse) => void,
  ): void;
}

declare var FB: Facebook;

declare global {
  interface Window {
    fbAsyncInit: Function;
  }
}

export class FacebookLoginWeb extends WebPlugin implements FacebookLoginPlugin {
  constructor() {
    super({
      name: 'FacebookLogin',
      platforms: ['web'],
    });
  }

  async login(options: {
    permissions: string[];
  }): Promise<FacebookLoginResponse> {
    console.log('FacebookLoginWeb.login', options);

    return new Promise<FacebookLoginResponse>((resolve, reject) => {
      FB.login(
        response => {
          console.debug('FB.login', response);

          if (response.status === 'connected') {
            resolve({
              accessToken: {
                token: response.authResponse.accessToken,
              },
            });
          } else {
            reject({
              accessToken: {
                token: null,
              },
            });
          }
        },
        { scope: options.permissions.join(',') },
      );
    });
  }

  async logout(): Promise<void> {
    return new Promise<void>(resolve => {
      FB.logout(() => resolve());
    });
  }

  async getCurrentAccessToken(): Promise<FacebookCurrentAccessTokenResponse> {
    return new Promise<FacebookCurrentAccessTokenResponse>(
      (resolve, reject) => {
        FB.getLoginStatus(response => {
          if (response.status === 'connected') {
            const result: FacebookCurrentAccessTokenResponse = {
              accessToken: {
                applicationId: undefined,
                declinedPermissions: [],
                expires: undefined,
                isExpired: undefined,
                lastRefresh: undefined,
                permissions: [],
                token: response.authResponse.accessToken,
                userId: response.authResponse.userID,
              },
            };
            resolve(result);
          } else {
            reject({
              accessToken: {
                token: null,
              },
            });
          }
        });
      },
    );
  }

  async getProfile<T extends object>(options: {
    fields: readonly string[];
  }): Promise<T> {
    const fields = options.fields.join(',');

    return new Promise<T>((resolve, reject) => {
      FB.api<{ fields: string }, FacebookGetProfileResponse>(
        '/me',
        { fields },
        response => {
          if (response.error) {
            reject(response.error.message);

            return;
          }

          resolve(<T>response);
        },
      );
    });
  }
}
