import Fluent
import Vapor

struct IssuedChallengeDTO: Content {
    let keyID: String
    let challenge: Data

    init(keyID: String,
         challenge: Data = Data(AES.GCM.Nonce())) {
        self.keyID = keyID
        self.challenge = challenge
    }

    func toModel() -> IssuedChallenge {
        let model = IssuedChallenge()
        model.id = UUID()
        model.keyID = keyID
        model.challenge = challenge
        return model
    }
}
