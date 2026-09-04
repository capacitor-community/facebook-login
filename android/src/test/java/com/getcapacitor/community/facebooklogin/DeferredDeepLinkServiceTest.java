package com.getcapacitor.community.facebooklogin;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.Test;

public class DeferredDeepLinkServiceTest {

    @Test
    public void returnsCompleteFetchedPayload() {
        FakeScheduler scheduler = new FakeScheduler();
        DeferredDeepLinkService.Data expected = new DeferredDeepLinkService.Data(
            "https://example.com/deferred-link",
            "neutral-promotion",
            Map.of("source", "automated-test")
        );
        DeferredDeepLinkService service = new DeferredDeepLinkService((callback) -> callback.onFetched(expected), scheduler);
        AtomicReference<DeferredDeepLinkService.Data> result = new AtomicReference<>();

        service.fetch(callback(result, new AtomicReference<>()));

        assertSame(expected, result.get());
        assertEquals("https://example.com/deferred-link", result.get().getUri());
        assertEquals("neutral-promotion", result.get().getPromotionCode());
        assertEquals("automated-test", result.get().getArguments().get("source"));
        assertEquals(0, scheduler.size());
    }

    @Test
    public void retriesMissingDataUntilItSucceeds() {
        FakeScheduler scheduler = new FakeScheduler();
        AtomicInteger attempts = new AtomicInteger();
        DeferredDeepLinkService.Data expected = new DeferredDeepLinkService.Data("https://example.com/deferred-link", null, Map.of());
        DeferredDeepLinkService service = new DeferredDeepLinkService(
            (callback) -> callback.onFetched(attempts.incrementAndGet() == 3 ? expected : null),
            scheduler
        );
        AtomicReference<DeferredDeepLinkService.Data> result = new AtomicReference<>();

        service.fetch(callback(result, new AtomicReference<>()));
        scheduler.runNext();
        scheduler.runNext();

        assertSame(expected, result.get());
        assertEquals(3, attempts.get());
        assertEquals(List.of(2000L, 2000L), scheduler.getDelays());
    }

    @Test
    public void rejectsAfterFiveRetriesFollowingTheInitialAttempt() {
        FakeScheduler scheduler = new FakeScheduler();
        AtomicInteger attempts = new AtomicInteger();
        DeferredDeepLinkService service = new DeferredDeepLinkService((callback) -> {
            attempts.incrementAndGet();
            callback.onFetched(null);
        }, scheduler);
        AtomicReference<RuntimeException> error = new AtomicReference<>();

        service.fetch(callback(new AtomicReference<>(), error));
        scheduler.runAll();

        assertEquals(6, attempts.get());
        assertEquals(5, scheduler.getDelays().size());
        assertEquals("No deferred deep link data available after retries", error.get().getMessage());
    }

    @Test
    public void reportsSynchronousSdkFailure() {
        RuntimeException expected = new RuntimeException("Missing Facebook app ID");
        DeferredDeepLinkService service = new DeferredDeepLinkService((callback) -> {
            throw expected;
        }, new FakeScheduler());
        AtomicReference<RuntimeException> error = new AtomicReference<>();

        service.fetch(callback(new AtomicReference<>(), error));

        assertSame(expected, error.get());
    }

    private DeferredDeepLinkService.ResultCallback callback(
        AtomicReference<DeferredDeepLinkService.Data> result,
        AtomicReference<RuntimeException> error
    ) {
        return new DeferredDeepLinkService.ResultCallback() {
            @Override
            public void onSuccess(DeferredDeepLinkService.Data data) {
                result.set(data);
            }

            @Override
            public void onError(RuntimeException exception) {
                error.set(exception);
            }
        };
    }

    private static final class FakeScheduler implements DeferredDeepLinkService.RetryScheduler {

        private final Queue<Runnable> actions = new ArrayDeque<>();
        private final List<Long> delays = new ArrayList<>();

        @Override
        public void schedule(Runnable action, long delayMillis) {
            actions.add(action);
            delays.add(delayMillis);
        }

        void runNext() {
            actions.remove().run();
        }

        void runAll() {
            while (!actions.isEmpty()) {
                runNext();
            }
        }

        int size() {
            return actions.size();
        }

        List<Long> getDelays() {
            return delays;
        }
    }
}
