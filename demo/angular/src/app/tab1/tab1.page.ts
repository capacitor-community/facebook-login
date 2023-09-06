import { Component } from '@angular/core';
import type { ViewWillEnter } from '@ionic/angular';

import type { AuthService } from '../auth/auth.service';

@Component({
  selector: 'app-tab1',
  templateUrl: 'tab1.page.html',
  styleUrls: ['tab1.page.scss'],
})
export class Tab1Page implements ViewWillEnter {
  public email = null;
  constructor(public auth: AuthService) {}

  async ionViewWillEnter(): Promise<void> {
    this.email = await this.auth.getEmail();
  }

  signOut(): void {
    this.auth.signOut();
  }
}
