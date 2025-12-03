import { Component } from '@angular/core';

import { AuthService } from './auth.service';
import { IonicModule } from '@ionic/angular';

@Component({
    selector: 'app-auth',
    templateUrl: './auth.page.html',
    styleUrls: ['./auth.page.scss'],
    imports: [IonicModule],
})
export class AuthPage {
  constructor(public auth: AuthService) {}

  signIn(): void {
    this.auth.signIn();
  }
}
