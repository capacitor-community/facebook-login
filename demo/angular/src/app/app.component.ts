import { Component } from '@angular/core';
import { FacebookLogin } from '@capacitor-community/facebook-login';
import { Platform } from '@ionic/angular';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  standalone: false,
})
export class AppComponent {
  constructor(private platform: Platform) {
    this.initializeApp();
  }

  initializeApp(): void {
    this.platform.ready().then(() => {
      FacebookLogin.initialize({ appId: '105890006170720' });
    });
  }
}
