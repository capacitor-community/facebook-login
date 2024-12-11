import { WebPlugin } from '@capacitor/core';

import type {
  FacebookLoginPlugin,
  FacebookLoginResponse,
  FacebookCurrentAccessTokenResponse,
  LimitedFacebookLoginResponse,
  FacebookGetLoginStatusResponse,
  FacebookGetProfileResponse,
  FacebookConfiguration,
} from './definitions';

declare interface Facebook {
  init(
    options: Partial<{
      appId: string;
      autoLogAppEvents: boolean;
      xfbml: boolean;
      version: string;
    }>,
  ): void;

  login(handle: (response: any) => void, options?: { scope: string }): void;

  logout(handle: (response: any) => void): void;

  reauthorize(handle: (response: any) => void): void;

  getLoginStatus(
    handle: (response: FacebookGetLoginStatusResponse) => void,
  ): void;

  api<TResponse>(path: string, callback: (response: TResponse) => void): void;
  api<TParams extends Record<string, unknown>, TResponse>(
    path: string,
    params: TParams,
    callback: (response: TResponse) => void,
  ): void;
  api<TParams extends Record<string, unknown>, TResponse>(
    path: string,
    method: 'get' | 'post' | 'delete',
    params: TParams,
    callback: (response: TResponse) => void,
  ): void;
  logEvent(handle: (response: any) => void, options: { eventName: string }): void;
  setAutoLogAppEventsEnabled(
    handle: (response: any) => void,
    options: { enabled: boolean },
  ): void;
  setAdvertiserTrackingEnabled(
    handle: (response: any) => void,
    options: { enabled: boolean },
  ): void;
  setAdvertiserIDCollectionEnabled(
    handle: (response: any) => void,
    options: { enabled: boolean },
  ): void;
}

declare let FB: Facebook;

declare global {
  interface Window {
    fbAsyncInit: () => void;
  }
}

export class FacebookLoginWeb extends WebPlugin implements FacebookLoginPlugin {
  async initialize(options: Partial<FacebookConfiguration>): Promise<void> {
    const defaultOptions = { version: 'v17.0' };
    await this.loadScript(options.locale);
    return FB.init({ ...defaultOptions, ...options });
  }

  private loadScript(locale: string | undefined): Promise<void> {
    if (typeof document === 'undefined') {
      return Promise.reject('document global not found');
    }
    const scriptId = 'fb';
    const scriptEl = document.getElementById(scriptId);
    if (scriptEl) {
      // already loaded
      return Promise.resolve();
    }

    const head = document.getElementsByTagName('head')[0];
    const script = document.createElement('script');
    return new Promise<void>(resolve => {
      script.onload = () => resolve();
      script.defer = true;
      script.async = true;
      script.id = scriptId;
      script.src = `https://connect.facebook.net/${locale ?? 'en_US'}/sdk.js`;
      head.appendChild(script);
    });
  }

  async login(options: {
    permissions: string[];
  }): Promise<FacebookLoginResponse> {
    return new Promise<FacebookLoginResponse>((resolve, reject) => {
      FB.login(
        response => {
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

  async limitedLogin(options: {
    permissions: string[];
    tracking?: 'limited' | 'enabled';
    nonce?: string;
  }): Promise<LimitedFacebookLoginResponse> {
    return new Promise<LimitedFacebookLoginResponse>((_, reject) => {
      console.log(options)
      reject('Not implemented')
    });
  }

  async logout(): Promise<void> {
    return new Promise<void>(resolve => FB.logout(() => resolve()));
  }

  async reauthorize(): Promise<FacebookLoginResponse> {
    return new Promise<FacebookLoginResponse>(resolve =>
      FB.reauthorize(it => resolve(it)),
    );
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

  async getProfile<T extends Record<string, unknown>>(options: {
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
          resolve(response as unknown as T);
        },
      );
    });
  }

  async logEvent(): Promise<void> {
    return Promise.resolve();
  }

  async setAutoLogAppEventsEnabled(): Promise<void> {
    return Promise.resolve();
  }

  async setAdvertiserTrackingEnabled(): Promise<void> {
    return Promise.resolve();
  }

  async setAdvertiserIDCollectionEnabled(): Promise<void> {
    return Promise.resolve();
  }
}
