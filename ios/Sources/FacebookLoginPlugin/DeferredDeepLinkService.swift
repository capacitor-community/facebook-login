import Foundation
import FBSDKCoreKit

protocol DeferredDeepLinkFetching {
    func fetch(completion: @escaping (URL?, Error?) -> Void)
}

struct FacebookDeferredDeepLinkFetcher: DeferredDeepLinkFetching {
    func fetch(completion: @escaping (URL?, Error?) -> Void) {
        ApplicationDelegate.shared.initializeSDK()
        AppLinkUtility.fetchDeferredAppLink(completion)
    }
}

enum DeferredDeepLinkError: LocalizedError {
    case missingConfiguration(String)
    case sdk(Error)

    var errorDescription: String? {
        switch self {
        case .missingConfiguration(let key):
            return "Missing \(key) in Info.plist. Configure Facebook SDK before calling getDeferredDeepLink()."
        case .sdk(let error):
            return "Failed to fetch deferred App Link: \(error.localizedDescription)"
        }
    }
}

final class DeferredDeepLinkService {
    typealias InfoDictionaryProvider = () -> [String: Any]

    private let infoDictionaryProvider: InfoDictionaryProvider
    private let fetcher: DeferredDeepLinkFetching

    init(infoDictionaryProvider: @escaping InfoDictionaryProvider, fetcher: DeferredDeepLinkFetching) {
        self.infoDictionaryProvider = infoDictionaryProvider
        self.fetcher = fetcher
    }

    func fetch(completion: @escaping (Result<URL?, DeferredDeepLinkError>) -> Void) {
        let infoDictionary = infoDictionaryProvider()
        for key in ["FacebookAppID", "FacebookClientToken"] where !Self.hasValue(for: key, in: infoDictionary) {
            completion(.failure(.missingConfiguration(key)))
            return
        }

        fetcher.fetch { url, error in
            if let error {
                completion(.failure(.sdk(error)))
            } else {
                completion(.success(url))
            }
        }
    }

    private static func hasValue(for key: String, in infoDictionary: [String: Any]) -> Bool {
        guard let value = infoDictionary[key] as? String else {
            return false
        }
        return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
