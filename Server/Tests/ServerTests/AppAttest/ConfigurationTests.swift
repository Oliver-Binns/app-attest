@testable import Server
import XCTVapor
import Testing
import Fluent

@Suite(.serialized)
struct ConfigurationTests {
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

    @Test("Check app configuration correctly")
    func checkConfiguration() async throws {
        try await withApp { app in
            #expect(app.routes.all.count == 3)

            #expect(app.routes.all.contains(where: { $0.path.last == "challenge" }))
            #expect(app.routes.all.contains(where: { $0.path.last == "verify" }))
            #expect(app.routes.all.contains(where: { $0.path.last == "hello-world" }))
        }
    }
}
