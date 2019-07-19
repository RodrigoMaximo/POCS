import Foundation

protocol PersistenceProtocol {

}

enum Persistence: PersistenceProtocol {
    static func save<T: HasKey>(_ object: T) {
        UserDefaults().set(true, forKey: object.id)
    }

    static func remove<T: HasKey>(_ object: T) {
        UserDefaults().removeObject(forKey: object.id)
    }

    static func getObject(of key: String) -> Bool {
        return UserDefaults().object(forKey: key) as? Bool ?? false
    }
}
