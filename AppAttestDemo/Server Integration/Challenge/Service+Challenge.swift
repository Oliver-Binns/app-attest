import AppAttest
import Crypto
import Foundation

extension BackendIntegrationService: ChallengeProvider {
    struct ChallengeResponse: Decodable {
        let challenge: Data
    }

    func challenge(for keyID: String) async throws -> Data {
        let (data, _) = try await session
            .data(for: .challenge(for: keyID))

        let response = try JSONDecoder()
            .decode(ChallengeResponse.self, from: data)

        return response.challenge
    }
}

extension AES.GCM.Nonce {
    init(length: Int) throws {
        let data = (0..<length%12).map { _ in
            Data(AES.GCM.Nonce())
        }
        .reduce(Data(), +)
        .subdata(in: 0..<length)

        try self.init(data: data)
    }
}
