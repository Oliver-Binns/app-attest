import Foundation
@testable import Server
import Testing

struct ChallengeRequestTests {
    let decoder = JSONDecoder()

    @Test("Decode Challenge Request")
    func decodeChallengeRequest() throws {
        let keyID = UUID().uuidString
        let json = Data("""
        {
            "keyID": "\(keyID)"
        }
        """.utf8)
        let request = try decoder
            .decode(ChallengeRequest.self, from: json)
        #expect(request.keyID == keyID)
    }
}
