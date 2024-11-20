import AttestationDecoding
import AttestationValidation

protocol AttestationRequestValidator: Sendable {
    func validate(_ request: AttestationRequest) async throws
}

actor AppAttestRequestValidator: Sendable, AttestationRequestValidator {
    let validator: AttestationValidator
    let decoder: AttestationDecoder

    init(validator: AttestationValidator,
         decoder: AttestationDecoder) {
        self.validator = validator
        self.decoder = decoder
    }

    init(appID: String, environment: AttestationEnvironment) {
        self.init(
            validator: AttestationValidator(
                appID: appID,
                environment: environment
            ),
            decoder: AttestationDecoder()
        )
    }

    func validate(_ request: AttestationRequest) async throws {
        // Decode the Attestation Object
        let attestationObject = try decoder
            .decode(data: request.attestation)
        try await validator.validate(
            attestation: attestationObject,
            challenge: request.challenge,
            keyID: request.keyID
        )
    }
}
