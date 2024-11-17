import AppAttest
import Foundation

struct RemoteChallengeProvider: ChallengeProvider {
    struct ChallengeResponse: Decodable {
        let challenge: Data
    }

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func challenge(for keyID: String) async throws -> Data {
        let (data, _) = try await session
            .data(for: .challenge(for: keyID))

        let response = try JSONDecoder()
            .decode(ChallengeResponse.self, from: data)

        return response.challenge
    }
}

extension URLRequest {
    struct ChallengeRequest: Encodable {
        let keyID: String
    }

    static func challenge(for keyID: String) throws -> URLRequest {
        var request = URLRequest(url: .challenge)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let requestBody = ChallengeRequest(keyID: keyID)
        request.httpBody = try JSONEncoder()
            .encode(requestBody)

        return request
    }
}

extension URL {
    static var challenge: URL {
        URL(string: "http://localhost:8080/challenge")!
    }
}
