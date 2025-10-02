import Foundation

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
        local.appending(path: "challenge")
    }
}
