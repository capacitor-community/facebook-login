import { Component, inject } from '@angular/core';
import type { ViewWillEnter } from '@ionic/angular/standalone';

import { AuthService } from '../auth/auth.service';
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonList,
  IonItem,
  IonText,
  IonButton,
} from '@ionic/angular/standalone';

@Component({
  selector: 'app-tab1',
  templateUrl: 'tab1.page.html',
  styleUrls: ['tab1.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonText, IonButton],
})
export class Tab1Page implements ViewWillEnter {
  auth = inject(AuthService);

  public email = '';


  constructor() {}

  async ionViewWillEnter(): Promise<void> {
    const email = await this.auth.getEmail();
    if (email !== undefined) {
      this.email = email;
    }
  }

  signOut(): void {
    this.auth.signOut();
  }
}
