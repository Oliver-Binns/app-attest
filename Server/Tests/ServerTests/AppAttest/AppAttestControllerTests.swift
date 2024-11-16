@testable import Server
import XCTVapor
import Testing
import Fluent

@Suite("AppAttestController Tests", .serialized)
struct AppAttestControllerTests {
    private func withApp(_ test: (Application) async throws -> Void) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
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
                let models = try await IssuedChallenge.query(on: app.db)
                    .all()
                #expect(models.count == 1)
                #expect(models.first?.keyID == keyID)
            })
        }
    }
}
