package com.getcapacitor.community.facebooklogin;

final class DeferredDeepLinkService {

    interface Fetcher {
        void fetch(FetchCallback callback);
    }

    interface FetchCallback {
        void onFetched(String uri);
    }

    interface ResultCallback {
        void onSuccess(String uri);

        void onError(RuntimeException error);
    }

    private final Fetcher fetcher;

    DeferredDeepLinkService(Fetcher fetcher) {
        this.fetcher = fetcher;
    }

    void fetch(ResultCallback callback) {
        try {
            fetcher.fetch(callback::onSuccess);
        } catch (RuntimeException error) {
            callback.onError(error);
        }
    }
}
