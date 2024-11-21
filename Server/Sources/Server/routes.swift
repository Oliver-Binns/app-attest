import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: HelloWorldController())
    try app.register(collection:
        AppAttestController(
            validator: AppAttestRequestValidator(
                appID: "Z86DH46P79.uk.co.oliverbinns.app-attest",
                environment: .development
            )
        )
    )
}
