import Fluent
import Vapor

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class IssuedChallenge: Model, @unchecked Sendable {
    static let schema = "challenges"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "key_id")
    var keyID: String

    @Field(key: "challenge")
    var challenge: Data

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, keyID: String) {
        self.id = id
        self.keyID = keyID
    }
}
