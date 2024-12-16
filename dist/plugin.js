var FacebookLoginPlugin = (function (exports, core) {
    'use strict';

    const FacebookLogin = core.registerPlugin('FacebookLogin', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.FacebookLoginWeb()),
    });

    class FacebookLoginWeb extends core.WebPlugin {
        async initialize(options) {
            const defaultOptions = { version: 'v17.0' };
            await this.loadScript(options.locale);
            return FB.init(Object.assign(Object.assign({}, defaultOptions), options));
        }
        loadScript(locale) {
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
            return new Promise(resolve => {
                script.onload = () => resolve();
                script.defer = true;
                script.async = true;
                script.id = scriptId;
                script.src = `https://connect.facebook.net/${locale !== null && locale !== void 0 ? locale : 'en_US'}/sdk.js`;
                head.appendChild(script);
            });
        }
        async login(options) {
            return new Promise((resolve, reject) => {
                FB.login(response => {
                    if (response.status === 'connected') {
                        resolve({
                            accessToken: {
                                token: response.authResponse.accessToken,
                            },
                        });
                    }
                    else {
                        reject({
                            accessToken: {
                                token: null,
                            },
                        });
                    }
                }, { scope: options.permissions.join(',') });
            });
        }
        async limitedLogin(options) {
            return new Promise((_, reject) => {
                console.log(options);
                reject('Not implemented');
            });
        }
        async logout() {
            return new Promise(resolve => FB.logout(() => resolve()));
        }
        async reauthorize() {
            return new Promise(resolve => FB.reauthorize(it => resolve(it)));
        }
        async getCurrentAccessToken() {
            return new Promise((resolve, reject) => {
                FB.getLoginStatus(response => {
                    if (response.status === 'connected') {
                        const result = {
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
                    }
                    else {
                        reject({
                            accessToken: {
                                token: null,
                            },
                        });
                    }
                });
            });
        }
        async getProfile(options) {
            const fields = options.fields.join(',');
            return new Promise((resolve, reject) => {
                FB.api('/me', { fields }, response => {
                    if (response.error) {
                        reject(response.error.message);
                        return;
                    }
                    resolve(response);
                });
            });
        }
        async logEvent() {
            return Promise.resolve();
        }
        async setAutoLogAppEventsEnabled() {
            return Promise.resolve();
        }
        async setAdvertiserTrackingEnabled() {
            return Promise.resolve();
        }
        async setAdvertiserIDCollectionEnabled() {
            return Promise.resolve();
        }
        async getDeferredDeepLink() {
            return Promise.resolve({ uri: undefined });
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        FacebookLoginWeb: FacebookLoginWeb
    });

    exports.FacebookLogin = FacebookLogin;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
