# App Events

Complete [Configuration](./configuration.md) before logging Facebook App Events.

## Platform behavior

| Method                             | Android                 | iOS       | Web       |
| ---------------------------------- | ----------------------- | --------- | --------- |
| `logEvent`                         | Supported               | Supported | Supported |
| `setAutoLogAppEventsEnabled`       | Promise remains pending | Supported | No-op     |
| `setAdvertiserTrackingEnabled`     | Not implemented         | Supported | No-op     |
| `setAdvertiserIDCollectionEnabled` | Promise remains pending | Supported | No-op     |

## Log an event

```ts
import { FacebookLogin } from '@capacitor-community/facebook-login';

await FacebookLogin.logEvent({
  eventName: 'completed_tutorial',
  parameters: {
    content_name: 'Getting Started',
    step: 3,
  },
});
```

Parameter values must be strings or numbers. Other value types are not part of the public API and are ignored by the native implementations.

## Automatic events and advertiser settings

These settings can be awaited on iOS:

```ts
await FacebookLogin.setAutoLogAppEventsEnabled({ enabled: true });
await FacebookLogin.setAdvertiserIDCollectionEnabled({ enabled: true });
await FacebookLogin.setAdvertiserTrackingEnabled({ enabled: true });
```

Request App Tracking Transparency permission separately before enabling advertiser tracking when your iOS app requires it.

On Android, `setAutoLogAppEventsEnabled` and `setAdvertiserIDCollectionEnabled` apply the requested value, but their returned promises currently remain pending. `setAdvertiserTrackingEnabled` is not implemented on Android. All three methods are no-ops on Web.
