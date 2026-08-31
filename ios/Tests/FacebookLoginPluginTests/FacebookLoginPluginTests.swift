import XCTest
@testable import FacebookLoginPlugin

final class DeferredDeepLinkServiceTests: XCTestCase {
    func testMissingAppIDDoesNotCallSDK() {
        let fetcher = StubDeferredDeepLinkFetcher()
        let service = DeferredDeepLinkService(
            infoDictionaryProvider: { ["FacebookClientToken": "token"] },
            fetcher: fetcher
        )

        service.fetch { result in
            guard case .failure(.missingConfiguration(let key)) = result else {
                return XCTFail("Expected a missing configuration failure")
            }
            XCTAssertEqual(key, "FacebookAppID")
        }

        XCTAssertEqual(fetcher.invocationCount, 0)
    }

    func testWhitespaceClientTokenDoesNotCallSDK() {
        let fetcher = StubDeferredDeepLinkFetcher()
        let service = DeferredDeepLinkService(
            infoDictionaryProvider: {
                ["FacebookAppID": "123", "FacebookClientToken": "  \n"]
            },
            fetcher: fetcher
        )

        service.fetch { result in
            guard case .failure(.missingConfiguration(let key)) = result else {
                return XCTFail("Expected a missing configuration failure")
            }
            XCTAssertEqual(key, "FacebookClientToken")
        }

        XCTAssertEqual(fetcher.invocationCount, 0)
    }

    func testReturnsFetchedURL() {
        let expectedURL = URL(string: "https://example.com/deferred-link")!
        let fetcher = StubDeferredDeepLinkFetcher(url: expectedURL)
        let service = configuredService(fetcher: fetcher)

        service.fetch { result in
            guard case .success(let url) = result else {
                return XCTFail("Expected a successful result")
            }
            XCTAssertEqual(url, expectedURL)
        }

        XCTAssertEqual(fetcher.invocationCount, 1)
    }

    func testReturnsNilWhenNoDeferredLinkExists() {
        let fetcher = StubDeferredDeepLinkFetcher()
        let service = configuredService(fetcher: fetcher)

        service.fetch { result in
            guard case .success(let url) = result else {
                return XCTFail("Expected a successful result")
            }
            XCTAssertNil(url)
        }

        XCTAssertEqual(fetcher.invocationCount, 1)
    }

    func testReportsSDKError() {
        let expectedError = NSError(domain: "DeferredDeepLinkTests", code: 7)
        let fetcher = StubDeferredDeepLinkFetcher(error: expectedError)
        let service = configuredService(fetcher: fetcher)

        service.fetch { result in
            guard case .failure(.sdk(let error)) = result else {
                return XCTFail("Expected an SDK failure")
            }
            XCTAssertEqual(error as NSError, expectedError)
        }

        XCTAssertEqual(fetcher.invocationCount, 1)
    }

    private func configuredService(fetcher: DeferredDeepLinkFetching) -> DeferredDeepLinkService {
        return DeferredDeepLinkService(
            infoDictionaryProvider: {
                ["FacebookAppID": "123", "FacebookClientToken": "token"]
            },
            fetcher: fetcher
        )
    }
}

private final class StubDeferredDeepLinkFetcher: DeferredDeepLinkFetching {
    private let url: URL?
    private let error: Error?
    private(set) var invocationCount = 0

    init(url: URL? = nil, error: Error? = nil) {
        self.url = url
        self.error = error
    }

    func fetch(completion: @escaping (URL?, Error?) -> Void) {
        invocationCount += 1
        completion(url, error)
    }
}
