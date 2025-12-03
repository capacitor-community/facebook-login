import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { IonicModule } from '@ionic/angular';

import { Tab3Page } from './tab3.page';

@NgModule({
    imports: [IonicModule, CommonModule, FormsModule, RouterModule.forChild([{ path: '', component: Tab3Page }]), Tab3Page],
})
export class Tab3PageModule {}
