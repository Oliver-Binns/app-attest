import Fluent
import Vapor

struct HelloWorldController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("hello-world", use: helloWorld)
    }

    @Sendable
    func helloWorld(req: Request) async throws -> String {
        "Hello, world!"
    }
}
