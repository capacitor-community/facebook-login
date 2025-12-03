import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, RouterStateSnapshot, Router } from '@angular/router';

import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root',
})
export class AuthGuard {
  constructor(
    private auth: AuthService,
    private router: Router,
  ) {}

  async canActivate(_next: ActivatedRouteSnapshot, _state: RouterStateSnapshot): Promise<boolean> {
    const loginState = await this.auth.getCurrentState();
    console.log(['state', loginState, _next, _state]);
    if (loginState) {
      return true;
    } else {
      return this.router.navigate(['auth']);
    }
  }
}
