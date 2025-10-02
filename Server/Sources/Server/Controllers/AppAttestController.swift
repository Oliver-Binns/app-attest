import Fluent
import Vapor

struct ChallengeRequest: Content {
    let keyID: String
}

struct AttestationRequest: Content {
    let keyID: String
    let attestation: Data
}

struct AppAttestController: RouteCollection {
    let validator: AttestationRequestValidator

    func boot(routes: RoutesBuilder) throws {
        routes.post("challenge", use: challenge)
        routes.post("verify", use: verify)
    }

    @Sendable
    func challenge(req: Request) async throws -> IssuedChallengeDTO {
        // Extract key
        let keyID = try req.content
            .decode(ChallengeRequest.self)
            .keyID

        // Create challenge for attestation
        let challenge = try IssuedChallengeDTO(
            keyID: keyID
        )

        // Store challenge for validating `AttestationRequest`
        try await challenge.toModel().save(on: req.db)

        return challenge
    }

    @Sendable
    func verify(req: Request) async throws -> HTTPStatus {
        let request = try req.content.decode(AttestationRequest.self)
        // verify this against challenge in database
        let challenges = try await req.db.query(IssuedChallenge.self)
            .filter(\.$keyID, .equal, request.keyID)
            .all()

        // discard challenge it cannot be used again
        try await challenges.delete(force: true, on: req.db)

        // Ensure challenge is unique and was created within the last two minutes
        guard challenges.count == 1,
              let challenge = challenges.first,
              let twoMinutesAgo = Calendar.current.date(byAdding: .minute, value: -2, to: .now),
              let creationDate = challenge.createdAt,
              creationDate > twoMinutesAgo
        else {
            return .unauthorized
        }

        // Validate the Attestation Object
        do {
            try await validator.validate(
                request, against: challenge.challenge
            )
        } catch {
            return .unauthorized
        }

        // TODO: Store the Credential Cert and Receipt
        // https://developer.apple.com/documentation/devicecheck/validating-apps-that-connect-to-your-server#Store-the-public-key-and-receipt
        // This are used for validating assertions later

        return .ok
    }
}
