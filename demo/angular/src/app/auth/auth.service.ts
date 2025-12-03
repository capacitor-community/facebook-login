import { Injectable, inject } from '@angular/core';
import { FacebookLogin } from '@capacitor-community/facebook-login';
import { NavController } from '@ionic/angular/standalone';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  navCtrl = inject(NavController);



  constructor() {}

  async getCurrentState(): Promise<boolean> {
    const result = await FacebookLogin.getCurrentAccessToken().catch(() => undefined);
    return !(result === undefined || !result.accessToken);
  }

  async getEmail(): Promise<string | undefined> {
    const result = await FacebookLogin.getProfile<{
      email: string;
    }>({
      fields: ['email'],
    }).catch(() => undefined);
    if (result === undefined) {
      return undefined;
    }
    return result.email;
  }

  async signIn(): Promise<void> {
    const FACEBOOK_PERMISSIONS = ['email'];

    const result = await FacebookLogin.login({
      permissions: FACEBOOK_PERMISSIONS,
    });
    if (result?.accessToken) {
      this.navCtrl.navigateRoot(['/']);
    }
  }

  async signOut(): Promise<void> {
    await FacebookLogin.logout();
    this.navCtrl.navigateRoot(['/auth']);
  }
}
