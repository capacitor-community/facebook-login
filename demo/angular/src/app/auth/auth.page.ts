import { Component, OnInit } from '@angular/core';
import { AuthService } from '@/app/auth/auth.service';

@Component({
  selector: 'app-auth',
  templateUrl: './auth.page.html',
  styleUrls: ['./auth.page.scss'],
})
export class AuthPage implements OnInit {
  constructor(public auth: AuthService) {}

  ngOnInit() {}

  signIn() {
    this.auth.signIn();
  }
}
