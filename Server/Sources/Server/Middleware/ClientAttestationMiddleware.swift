import AttestationDecoding
import AttestationValidation
import Vapor

/// A middleware that enforces requests must provide an Attestation Object from Apple's DeviceCheck framework.
actor ClientAttestationMiddleware: AsyncMiddleware {
    private let decoder = AttestationDecoder()
    private let validator: AttestationValidator

    init(appID: String, environment: AttestationEnvironment) {
        validator = AttestationValidator(
            appID: appID,
            environment: environment
        )
    }

    func respond(to request: Request,
                 chainingTo next: any AsyncResponder) async throws -> Response {
        // Bearer token should be an app assertion
        // This should be validated or the request is rejected
        guard let assertion = request.headers.bearerAuthorization?.token
            // TODO: validate the assertion:
            // validator.validate(assertion: assertion, challenge: challenge, keyID: keyID)
        else {
            throw Abort(.unauthorized)
        }

        return try await next.respond(to: request)
    }
}
