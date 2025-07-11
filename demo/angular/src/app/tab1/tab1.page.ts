import { Component } from '@angular/core';
import type { ViewWillEnter } from '@ionic/angular';

import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'app-tab1',
  templateUrl: 'tab1.page.html',
  styleUrls: ['tab1.page.scss'],
  standalone: false,
})
export class Tab1Page implements ViewWillEnter {
  public email = '';
  constructor(public auth: AuthService) {}

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
