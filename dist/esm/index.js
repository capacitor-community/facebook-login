import { registerPlugin } from '@capacitor/core';
const FacebookLogin = registerPlugin('FacebookLogin', {
    web: () => import('./web').then(m => new m.FacebookLoginWeb()),
});
export * from './definitions';
export { FacebookLogin };
//# sourceMappingURL=index.js.map