var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import { WebPlugin } from '@capacitor/core';
;
export class FacebookLoginWeb extends WebPlugin {
    constructor() {
        super({
            name: 'FacebookLogin',
            platforms: ['web']
        });
    }
    login(options) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log('FacebookLoginWeb.login', options);
            return new Promise((resolve, reject) => {
                FB.login((response) => {
                    console.debug('FB.login', response);
                    if (response.status === 'connected') {
                        resolve(response.authResponse);
                    }
                    else {
                        reject(response);
                    }
                }, { scope: options.permissions.join(',') });
            });
        });
    }
    logout() {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => {
                FB.logout((response) => {
                    console.debug('FB.logout', response);
                    resolve();
                });
            });
        });
    }
    getCurrentAccessToken() {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => {
                FB.getLoginStatus((response) => {
                    console.debug('FB.getLoginStatus', response);
                    const result = {
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
                });
            });
        });
    }
}
const FacebookLogin = new FacebookLoginWeb();
export { FacebookLogin };
//# sourceMappingURL=web.js.map