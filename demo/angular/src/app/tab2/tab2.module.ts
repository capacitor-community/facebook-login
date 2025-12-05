import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { Tab2Page } from './tab2.page';

@NgModule({
  imports: [CommonModule, FormsModule, RouterModule.forChild([{ path: '', component: Tab2Page }]), Tab2Page],
})
export class Tab2PageModule {}
