package com.getcapacitor.community.facebooklogin;

import java.util.Collections;
import java.util.Map;

final class DeferredDeepLinkService {

    static final int DEFAULT_MAX_RETRIES = 5;
    static final long DEFAULT_RETRY_DELAY_MILLIS = 2000L;

    static final class Data {

        private final String uri;
        private final String promotionCode;
        private final Map<String, Object> arguments;

        Data(String uri, String promotionCode, Map<String, Object> arguments) {
            this.uri = uri;
            this.promotionCode = promotionCode;
            this.arguments = arguments == null ? Collections.emptyMap() : arguments;
        }

        String getUri() {
            return uri;
        }

        String getPromotionCode() {
            return promotionCode;
        }

        Map<String, Object> getArguments() {
            return arguments;
        }
    }

    interface Fetcher {
        void fetch(FetchCallback callback);
    }

    interface FetchCallback {
        void onFetched(Data data);
    }

    interface RetryScheduler {
        void schedule(Runnable action, long delayMillis);
    }

    interface ResultCallback {
        void onSuccess(Data data);

        void onError(RuntimeException error);
    }

    private final Fetcher fetcher;
    private final RetryScheduler retryScheduler;

    DeferredDeepLinkService(Fetcher fetcher, RetryScheduler retryScheduler) {
        this.fetcher = fetcher;
        this.retryScheduler = retryScheduler;
    }

    void fetch(ResultCallback callback) {
        fetch(callback, DEFAULT_MAX_RETRIES);
    }

    private void fetch(ResultCallback callback, int retriesRemaining) {
        try {
            fetcher.fetch((data) -> {
                if (data != null) {
                    callback.onSuccess(data);
                } else if (retriesRemaining > 0) {
                    retryScheduler.schedule(() -> fetch(callback, retriesRemaining - 1), DEFAULT_RETRY_DELAY_MILLIS);
                } else {
                    callback.onError(new RuntimeException("No deferred deep link data available after retries"));
                }
            });
        } catch (RuntimeException error) {
            callback.onError(error);
        }
    }
}
