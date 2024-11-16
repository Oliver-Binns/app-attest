import Fluent
import Vapor

struct ChallengeRequest: Content {
    let keyID: String
}

struct AppAttestController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("challenge", use: challenge)
    }

    @Sendable
    func challenge(req: Request) async throws -> IssuedChallengeDTO {
        // Extract Key
        let keyID = try req.content
            .decode(ChallengeRequest.self)
            .keyID

        // Create Challenge
        let challenge = IssuedChallengeDTO(
            keyID: keyID
        )

        // Store Challenge
        try await challenge.toModel().save(on: req.db)

        // Return Challenge
        return challenge
    }
}
