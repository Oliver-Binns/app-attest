import AppAttest
import Foundation

final class BackendIntegrationService {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
}
