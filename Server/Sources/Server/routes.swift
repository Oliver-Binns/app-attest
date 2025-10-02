import AttestationValidation
import Fluent
import Vapor

let appID = "Z86DH46P79.uk.co.oliverbinns.app-attest"
let environment: AttestationEnvironment = .development

func routes(_ app: Application) throws {
    try app.grouped(
        ClientAttestationMiddleware(
            appID: appID,
            environment: environment
        )
    ).register(collection: HelloWorldController())

    try app.register(collection:
        AppAttestController(
            validator: AppAttestRequestValidator(
                appID: appID,
                environment: environment
            )
        )
    )
}
