import { Component, inject } from '@angular/core';

import { AuthService } from './auth.service';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonButton, IonText } from '@ionic/angular/standalone';

@Component({
  selector: 'app-auth',
  templateUrl: './auth.page.html',
  styleUrls: ['./auth.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonButton, IonText],
})
export class AuthPage {
  auth = inject(AuthService);

  constructor() {}

  signIn(): void {
    this.auth.signIn();
  }
}
