import AttestationDecoding
import AttestationValidation

extension AttestationDecoding.AttestationStatement: AttestationValidation.AttestationStatement { }
extension AttestationDecoding.AuthenticatorData: AttestationValidation.AuthenticatorData {
    public var environment: AttestationValidation.AttestationEnvironment {
        isProduction ? .production : .development
    }
}
extension AttestationDecoding.AttestationObject: AttestationValidation.AttestationObject { }
