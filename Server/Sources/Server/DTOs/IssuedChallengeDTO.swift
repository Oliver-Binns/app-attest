import Fluent
import Vapor

struct IssuedChallengeDTO: Content {
    let keyID: String
    let challenge: Data

    init(keyID: String) throws {
        self.keyID = keyID
        self.challenge = try Data(AES.GCM.Nonce(length: 16))
    }

    func toModel() -> IssuedChallenge {
        let model = IssuedChallenge()
        model.id = UUID()
        model.keyID = keyID
        model.challenge = challenge
        return model
    }
}
