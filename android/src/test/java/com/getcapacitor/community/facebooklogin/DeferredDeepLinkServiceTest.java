package com.getcapacitor.community.facebooklogin;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;

import java.util.concurrent.atomic.AtomicReference;
import org.junit.Test;

public class DeferredDeepLinkServiceTest {

    @Test
    public void returnsFetchedUri() {
        DeferredDeepLinkService service = new DeferredDeepLinkService((callback) ->
            callback.onFetched("https://example.com/deferred-link")
        );
        AtomicReference<String> result = new AtomicReference<>();

        service.fetch(callback(result, new AtomicReference<>()));

        assertEquals("https://example.com/deferred-link", result.get());
    }

    @Test
    public void returnsNullWhenNoDeferredLinkExists() {
        DeferredDeepLinkService service = new DeferredDeepLinkService((callback) -> callback.onFetched(null));
        AtomicReference<String> result = new AtomicReference<>("unexpected");

        service.fetch(callback(result, new AtomicReference<>()));

        assertNull(result.get());
    }

    @Test
    public void reportsSynchronousSdkFailure() {
        RuntimeException expected = new RuntimeException("Missing Facebook app ID");
        DeferredDeepLinkService service = new DeferredDeepLinkService((callback) -> {
            throw expected;
        });
        AtomicReference<RuntimeException> error = new AtomicReference<>();

        service.fetch(callback(new AtomicReference<>(), error));

        assertSame(expected, error.get());
    }

    private DeferredDeepLinkService.ResultCallback callback(AtomicReference<String> result, AtomicReference<RuntimeException> error) {
        return new DeferredDeepLinkService.ResultCallback() {
            @Override
            public void onSuccess(String uri) {
                result.set(uri);
            }

            @Override
            public void onError(RuntimeException exception) {
                error.set(exception);
            }
        };
    }
}
