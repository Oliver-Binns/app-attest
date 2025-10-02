import AttestationDecoding
@testable import AttestationValidation
@testable import Server
import XCTVapor
import Testing
import Fluent

@Suite("AppAttestController Tests", .serialized)
struct AppAttestControllerTests {
    private func withApp(_ test: (Application) async throws -> Void) async throws {
        let app = try await Application.make(.testing)

        let components = DateComponents(
            year: 2024, month: 11, day: 21,
            hour: 12, minute: 0
        )

        let date = try #require(
            Calendar.current.date(from: components)
        )

        let validator = AttestationValidator(
            appID: "Z86DH46P79.uk.co.oliverbinns.app-attest",
            environment: .development,
            validationDate: date
        )
        let collection = AppAttestController(
            validator: AppAttestRequestValidator(
                validator: validator,
                decoder: AttestationDecoder()
            )
        )

        do {
            app.databases.use(.sqlite(.memory), as: .sqlite)
            app.migrations.add(CreateAppInstance())
            try app.register(collection: collection)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test("Issuing a challenge to a new device")
    func issueChallenge() async throws {
        let keyID = UUID().uuidString

        try await withApp { app in
            try await app.test(.POST, "challenge", beforeRequest: { req in
                try req.content.encode(ChallengeRequest(keyID: keyID))
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)

                let content = try res.content
                    .decode(IssuedChallenge.self)
                #expect(content.keyID == keyID)

                // unique one-time challenge, at least 16 bytes in length:
                #expect(content.challenge.count >= 16)

                // Data is saved for re-validation at a later date.
                let models = try await IssuedChallenge
                    .query(on: app.db)
                    .all()
                #expect(models.count == 1)
                #expect(models.first?.keyID == keyID)
            })
        }
    }

    @Test("Verifying an assertion from a new device - returns 401 if no challenges")
    func verifyNoChallenge() async throws {
        let keyID = UUID().uuidString
        let challenge = try IssuedChallengeDTO(keyID: keyID)
        let request = AttestationRequest(
            keyID: keyID,
            attestation: Data()
        )

        try await withApp { app in
            try await app.test(.POST, "verify", beforeRequest: { req in
                try req.content.encode(request)
            }, afterResponse: { res async throws in
                #expect(res.status == .unauthorized)
            })
        }
    }

    // Fluent does not allow the `createdAt` date to be set manually
    //
    // This test succeeds because the credential validation fails
    // rather than because the challenge is too old
    //
    // TODO: fix this test so it correctly checks the challenge age logic
    @Test("Verifying an assertion from a new device - returns 401 if challenge too old")
    func verifyChallengeTooOld() async throws {
        let keyID = UUID().uuidString
        let challenge = try Data(AES.GCM.Nonce(length: 16))

        let request = AttestationRequest(
            keyID: keyID,
            attestation: Data()
        )

        try await withApp { app in
            let issuedChallenge = IssuedChallenge()

            issuedChallenge.keyID = keyID
            issuedChallenge.challenge = challenge
            issuedChallenge.createdAt = Date(timeIntervalSinceNow: -180)

            try await issuedChallenge.save(on: app.db)

            try await app.test(.POST, "verify", beforeRequest: { req in
                try req.content.encode(request)
            }, afterResponse: { res async throws in
                #expect(res.status == .unauthorized)
            })
        }
    }

    @Test("Verifying an assertion from a new device - returns 200 for Valid Attestation")
    func verifyChallengeSuccess() async throws {
        let keyID = "BWrvRtmH5td4GMI5jCmmPb7AgYi0BtHrKeGdnGypabw="
        let challenge = try #require(Data(base64Encoded: "r4+Rq1Fq3IZVnfCi58l9Dg=="))

        let request = try AttestationRequest(
            keyID: keyID,
            attestation: fromFile()
        )

        try await withApp { app in
            let issuedChallenge = IssuedChallenge()
            issuedChallenge.keyID = keyID
            issuedChallenge.challenge = challenge

            try await issuedChallenge.save(on: app.db)

            try await app.test(.POST, "verify", beforeRequest: { req in
                try req.content.encode(request)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
            })
        }
    }

    func fromFile(named filename: String = "attest-base64") throws -> Data {
        let url = try #require(Bundle.module.url(forResource: filename, withExtension: "txt"))
        let base64Data = try Data(contentsOf: url)
        let base64String = try #require(String(data: base64Data, encoding: .utf8))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return try #require(Data(base64Encoded: base64String))
    }
}
