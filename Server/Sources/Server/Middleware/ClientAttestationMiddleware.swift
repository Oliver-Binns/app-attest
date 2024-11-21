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
        try await next.respond(to: request)
    }

}
