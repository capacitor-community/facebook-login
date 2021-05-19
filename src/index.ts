import { registerPlugin } from '@capacitor/core';

import type { FacebookLoginPlugin } from './definitions';

const FacebookLogin = registerPlugin<FacebookLoginPlugin>('FacebookLogin', {
  web: () => import('./web').then(m => new m.FacebookLoginWeb()),
});

export * from './definitions';
export { FacebookLogin };
