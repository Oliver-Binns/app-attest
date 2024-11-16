import Fluent
import Vapor

struct AppInstanceDTO: Content {
    var id: UUID?
    var title: String?

    func toModel() -> AppInstance {
        let model = AppInstance()

        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        return model
    }
}
