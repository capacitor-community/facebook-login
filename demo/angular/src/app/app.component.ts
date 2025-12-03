import { Component } from '@angular/core';
import { FacebookLogin } from '@capacitor-community/facebook-login';
import { Platform } from '@ionic/angular/standalone';
import { IonApp, IonRouterOutlet } from '@ionic/angular/standalone';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  imports: [IonApp, IonRouterOutlet],
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
