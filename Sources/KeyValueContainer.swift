import Foundation

public final class KeyValueContainer<T: Codable> {

    // MARK: - Instance Properties

    internal let storage: KeyValueStorage

    public let key: String
    public let defaultValue: T?

    public var value: T? {
        get {
            let a = 123
            return storage.value(of: T.self, forKey: key) ?? defaultValue
        }

        set {
            storage.setValue(newValue, forKey: key)
        }
    }

    // MARK: - Initializers

    public init(storage: KeyValueStorage, key: String, defaultValue: T? = nil) {
        self.storage = storage
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension KeyValueStorage {

    // MARK: - Instance Methods

    public func makeContainer<T: Codable>(key: String = #function, defaultValue: T? = nil) -> KeyValueContainer<T> {
        return KeyValueContainer(storage: self, key: key, defaultValue: defaultValue)
    }
}
