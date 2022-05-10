import { Component } from '@angular/core';

import { Platform } from '@ionic/angular';
import { FacebookLogin } from "@capacitor-community/facebook-login";

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
})
export class AppComponent {
  constructor(
    private platform: Platform,
  ) {
    this.initializeApp();
  }

  initializeApp() {
    this.platform.ready().then(() => {
      FacebookLogin.initialize({appId: '105890006170720'});
    });
  }
}
