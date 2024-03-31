import { Component } from '@angular/core';

import { AuthService } from './auth.service';

@Component({
  selector: 'app-auth',
  templateUrl: './auth.page.html',
  styleUrls: ['./auth.page.scss'],
})
export class AuthPage {
  constructor(public auth: AuthService) {}

  signIn(): void {
    this.auth.signIn();
  }
}
