import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { Tab1Page } from './tab1.page';

@NgModule({
  imports: [CommonModule, FormsModule, RouterModule.forChild([{ path: '', component: Tab1Page }]), Tab1Page],
})
export class Tab1PageModule {}
