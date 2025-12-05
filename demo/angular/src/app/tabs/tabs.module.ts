import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { TabsPage } from './tabs.page';
import { TabsPageRoutingModule } from './tabs.router.module';

@NgModule({
  imports: [CommonModule, FormsModule, TabsPageRoutingModule, TabsPage],
})
export class TabsPageModule {}
