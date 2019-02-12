
import Foundation
import RealmSwift

class Message: Object {

  // MARK: - Init
    convenience  init(user: User, message: String) {
        self.init()
        self.name = user.name
        self.message = message
    }

  // MARK: - Persisted Properties
    dynamic var id = UUID().uuidString
    dynamic var message = ""
    dynamic var name = ""
    dynamic var isFavorite = false
    dynamic var timestamp = Date().timeIntervalSinceReferenceDate


  // MARK: - Dynamic properties
    var photoUrl: URL {
return imageUrlForName(self.name)
    }

  // MARK: - Meta
    override static func primaryKey() -> String? {
        return "id"
    }
    override class func indexedProperties() -> [String] {
        return ["isFavorite"]
    }

  // MARK: - Etc
    func toggleFavorite() {
        try? realm?.write {
            isFavorite  = !isFavorite
        }
    }

}
