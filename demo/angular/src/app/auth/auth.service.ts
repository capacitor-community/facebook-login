import { Injectable } from '@angular/core';
import { Plugins } from '@capacitor/core';
import { NavController } from '@ionic/angular';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor(public navCtrl: NavController) {}

  async getCurrentState(): Promise<boolean> {
    const result = await Plugins.FacebookLogin.getCurrentAccessToken();

    try {
      return result && result.accessToken;
    } catch (e) {
      return false;
    }
  }

  async signIn(): Promise<void> {
    const FACEBOOK_PERMISSIONS = ['email', 'user_birthday', 'user_photos', 'user_gender'];

    const result = await Plugins.FacebookLogin.login({ permissions: FACEBOOK_PERMISSIONS });
    if (result && result.accessToken) {
      this.navCtrl.navigateRoot(['/']);
    }
  }

  async signOut(): Promise<void> {
    await Plugins.FacebookLogin.logout();
    this.navCtrl.navigateRoot(['/auth']);
  }
}
