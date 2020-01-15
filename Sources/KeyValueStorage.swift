import Foundation

public protocol KeyValueStorage {

    // MARK: - Instance Methods

    func value<T: Codable>(of type: T.Type, forKey key: String) -> T?
    func setValue<T: Codable>(_ value: T?, forKey key: String)
}
