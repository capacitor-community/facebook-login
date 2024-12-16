import { Injectable } from '@angular/core';
import { FacebookLogin } from '@capacitor-community/facebook-login';
import { NavController } from '@ionic/angular';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor(public navCtrl: NavController) {}

  async getCurrentState(): Promise<boolean> {
    const result = await FacebookLogin.getCurrentAccessToken().catch(
      () => undefined,
    );
    return !(result === undefined || !result.accessToken);
  }

  async getEmail(): Promise<string> {
    const result = await FacebookLogin.getProfile<{
      email: string;
    }>({
      fields: ['email'],
    }).catch(() => undefined);
    if (result === undefined) {
      return null;
    }
    return result.email;
  }

  async signIn(): Promise<void> {
    const FACEBOOK_PERMISSIONS = [
      'email',
      'user_birthday',
      'user_photos',
      'user_gender',
    ];

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
