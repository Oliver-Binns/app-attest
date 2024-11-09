@testable import AttestationValidator
import Foundation
import Testing

struct AttestationValidatorTests {
    let sut: AttestationValidator

    init() throws {
        let components = DateComponents(
            year: 2024, month: 11, day: 01,
            hour: 12, minute: 0
        )

        let date = try #require(
            Calendar.current.date(from: components)
        )
        sut = AttestationValidator(validationDate: date)
    }

    @Test("Validate a valid attestation - throws no errors")
    func validateValidAttestation() async throws {
        try await sut.validateCertificateChain(
            attestation: .valid
        )
    }

    @Test("Validate an expired attestation - throws error")
    func validateExpiredAttestation() async throws {
        await #expect(throws: AttestationValidationError.invalidCertificateChain) {
            try await sut.validateCertificateChain(
                attestation: .expired
            )
        }
    }

    @Test("Validate an empty attestation - throws error")
    func validateIncorrectNumberOfCertificates() async throws {
        let attestation = MockAttestationObject(
            format: "apple-appattest",
            authenticatorData: Data(),
            statement: .empty
        )

        await #expect(throws: AttestationValidationError.invalidCertificateChain) {
            try await sut.validateCertificateChain(
                attestation: attestation
            )
        }
    }

    /// Apple's sample data appears to be incorrect:
    /// in particular the challenge specified does not appear to match.
    ///
    /// I have therefore generated my own sample data for this test:
    @Test("Correctly calculates client data hash")
    func clientDataHashCalculation() throws {
        let authenticatorData = try #require(Data(base64Encoded: """
        CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2xAAAAAAGFwcGF0d
        GVzdGRldmVsb3AAIG9BWcivC09zC1xluwgP1Zvt7I09591dFznuIYgnma
        TPpQECAyYgASFYIJ4vapTGQ5NqwIW+tkhsTOxBK4ubw1Ybxtoekioi8Zl
        eIlggcseOjEEzxVCQzl3Xbffk0yjwlwM+z+aFLqlIP4jl2LY=
        """.filter { !$0.isWhitespace }))

        let challenge = try #require(Data(base64Encoded: "XR79fDhFP05yhdB2"))

        let clientDataHash = sut.compose(
            authenticatorData: authenticatorData,
            withChallenge: challenge
        )

        let expectedHash = """
        CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2xAAAAAAGFwcGF0d
        GVzdGRldmVsb3AAIG9BWcivC09zC1xluwgP1Zvt7I09591dFznuIYgnma
        TPpQECAyYgASFYIJ4vapTGQ5NqwIW+tkhsTOxBK4ubw1Ybxtoekioi8Zl
        eIlggcseOjEEzxVCQzl3Xbffk0yjwlwM+z+aFLqlIP4jl2LZjY4q/7C/r
        iwY2HxzZ+wM02bmPoA8paJJWlRAjSPQ8qg==
        """.filter { !$0.isWhitespace }

        #expect(clientDataHash.base64EncodedString() == expectedHash)
    }

    @Test("Correctly calculates nonce")
    func nonceCalculation() throws {
        let compositeItem = try #require(Data(base64Encoded: """
        FVhAM8lQuf6dUUziohGjJtcaprEBSrTG+i+9qdmqGKZAAAAAAGFwcGF0d
        GVzdAAAAAAAAAAAIG0qxIRfEyMyL1kj8L2dItvlDga3uAEh/OKyteZunp
        jWpQECAyYgASFYIIwuDKtvkiOXDn9atukv16TW1iGmDlSGRL8Zdk7x74U
        2IlggEfbCtrtTsrui00aBl+S+qyw2ysDk4k9B81EyyUdeXCR0ZXN0X3Nl
        cnZlcl9jaGFsbGVuZ2U=
        """.filter { !$0.isWhitespace }))

        let expectedNonce = try #require(
            Data(base64Encoded: "+20WKnF+yrF3iQBQb6lNZ+4MHcPUWxLN3oG+/Fblt+s=")
        )

        #expect(sut.calculateNonce(composite: compositeItem) == expectedNonce)
    }
}
