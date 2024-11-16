import Fluent

struct CreateAppInstance: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}
