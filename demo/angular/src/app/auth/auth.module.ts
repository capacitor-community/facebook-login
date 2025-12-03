import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import type { Routes } from '@angular/router';
import { AuthPage } from './auth.page';

const routes: Routes = [
  {
    path: '',
    component: AuthPage,
  },
];

@NgModule({
  imports: [CommonModule, FormsModule, RouterModule.forChild(routes), AuthPage],
})
export class AuthPageModule {}
