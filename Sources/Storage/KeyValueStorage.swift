import Foundation

public protocol KeyValueStorage {

    // MARK: - Instance Methods

    func value<T: Codable>(of type: T.Type, forKey key: String) -> T?

    @discardableResult
    func setValue<T: Codable>(_ value: T?, forKey key: String) -> Bool
}
