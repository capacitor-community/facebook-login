# The Facebook SDK accesses these Google Play Services APIs through reflection
# when resolving attribution identifiers. Preserve them in minified apps so
# deferred App Links do not silently lose the advertiser ID.
-keep class com.google.android.gms.common.GooglePlayServicesUtil {
    public static int isGooglePlayServicesAvailable(android.content.Context);
}
-keep class com.google.android.gms.common.GooglePlayServicesUtilLight {
    public static int isGooglePlayServicesAvailable(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    public static com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    public java.lang.String getId();
    public boolean isLimitAdTrackingEnabled();
}
