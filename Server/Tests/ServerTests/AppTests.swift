@testable import Server
import XCTVapor
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct AppTests {
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

    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp { app in
            try await app.test(.GET, "hello-world", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }
}
