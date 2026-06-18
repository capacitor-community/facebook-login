import { vi } from 'vitest';

vi.mock('@capacitor-community/facebook-login', () => ({
  FacebookLogin: { initialize: vi.fn().mockResolvedValue(undefined) },
}));

import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { Platform, provideIonicAngular } from '@ionic/angular/standalone';
import { FacebookLogin } from '@capacitor-community/facebook-login';

import { AppComponent } from './app.component';

describe('AppComponent', () => {
  let platformReadySpy, readySpy;

  beforeEach(async () => {
    platformReadySpy = Promise.resolve();

    await TestBed.configureTestingModule({
      imports: [AppComponent],
      providers: [provideIonicAngular(), provideRouter([])],
    }).compileComponents();

    const platform = TestBed.inject(Platform);
    readySpy = vi.spyOn(platform, 'ready').mockReturnValue(platformReadySpy);
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.debugElement.componentInstance;
    expect(app).toBeTruthy();
  });

  it('should initialize the app', async () => {
    TestBed.createComponent(AppComponent);
    expect(readySpy).toHaveBeenCalled();
    await platformReadySpy;
    expect(FacebookLogin.initialize).toHaveBeenCalled();
  });

  // TODO: add more tests!
});
