import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(CreateAppInstance())
    app.middleware.use(ClientAttestationMiddleware(
        appID: "Z86DH46P79.uk.co.oliverbinns.app-attest",
        environment: .development
    ))
    // register routes
    try routes(app)
}
