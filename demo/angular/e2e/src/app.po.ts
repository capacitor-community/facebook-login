import { browser, by, element } from 'protractor';
import type { promise } from 'selenium-webdriver';

export class AppPage {
  navigateTo(): promise.Promise<string> {
    return browser.get('/');
  }

  getPageTitle(): promise.Promise<string> {
    return element(by.css('ion-title')).getText();
  }
}
