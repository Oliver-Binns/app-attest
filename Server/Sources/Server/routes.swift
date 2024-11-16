import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: HelloWorldController())
    try app.register(collection: AppAttestController())
}
