import Fluent

struct CreateAppInstance: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("challenges")
            .id()
            .field("key_id", .string, .required)
            .field("challenge", .data, .required)
            .field("created_at", .date, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("challenges").delete()
    }
}
