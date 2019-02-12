import { WebPlugin } from '@capacitor/core';
import { FacebookLoginPlugin, FacebookLoginResponse, FacebookCurrentAccessTokenResponse } from './definitions';

interface FacebookGetLoginStatusResponse {
  status: 'connected';
  authResponse: {
    accessToken: string,
    expiresIn: number,
    reauthorize_required_in: number,
    signedRequest: string,
    userID: string
  };
}

declare interface Facebook {
  init(options: {
    appId: string,
    autoLogAppEvents: boolean,
    xfbml: boolean,
    version: string
  }): void;

  login(handle: (response: any) => void, options?: { scope: string }): void;

  logout(handle: (response: any) => void): void;

  getLoginStatus(handle: (response: FacebookGetLoginStatusResponse) => void): void;
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
      platforms: ['web']
    });
  }

  async login(options: { permissions: string[] }): Promise<FacebookLoginResponse> {
    console.log('FacebookLoginWeb.login', options);

    return new Promise<FacebookLoginResponse>((resolve, reject) => {
      FB.login((response) => {
        console.debug('FB.login', response);

        if (response.status === 'connected') {
          resolve({
            accessToken: {
              token: response.authResponse.accessToken
            }
          });
        } else {
          reject({
            accessToken: {
              token: null
            }
          })
        }
      }, { scope: options.permissions.join(',') });  
    });
  }

  async logout(): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      FB.logout((response) => {
        console.debug('FB.logout', response);

        resolve();
      });
    });
  }

  async getCurrentAccessToken(): Promise<FacebookCurrentAccessTokenResponse> {
    return new Promise<FacebookCurrentAccessTokenResponse>((resolve, reject) => {
      FB.getLoginStatus((response) => {
        if (response.status === 'connected') {
          const result: FacebookCurrentAccessTokenResponse = {
            accessToken: {
              applicationId: null,
              declinedPermissions: [],
              expires: null,
              isExpired: null,
              lastRefresh: null,
              permissions: [],
              token: response.authResponse.accessToken,
              userId: response.authResponse.userID
            }
          };
          resolve(result);
        } else {
          reject({
            accessToken: {
              token: null
            }
          });
        }
      });
    });
  }
}

const FacebookLogin = new FacebookLoginWeb();

export { FacebookLogin };
