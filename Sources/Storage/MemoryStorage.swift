import Foundation

public final class MemoryStorage: KeyValueStorage {

    // MARK: - Type Properties

    public static let `default` = MemoryStorage()

    // MARK: - Instance Properties

    private var dictionaryQueue: DispatchQueue!
    private var dictionary: [String: Codable] = [:]

    public let keyPrefix: String

    public var queueQoS: DispatchQoS {
        dictionaryQueue.qos
    }

    public var allKeys: [String] {
        dictionaryQueue.sync {
            Array(dictionary.keys)
        }
    }

    // MARK: - Initializers

    public init(
        keyPrefix: String = "",
        queueQoS: DispatchQoS = .userInitiated
    ) {
        self.keyPrefix = keyPrefix

        self.dictionaryQueue = DispatchQueue(
            label: "\(Self.self): \(Unmanaged.passUnretained(self).toOpaque())",
            qos: queueQoS,
            attributes: .concurrent
        )
    }

    // MARK: - Instance Methods

    private func resolveKey(_ key: String) -> String {
        return keyPrefix.appending(key)
    }

    public func value<T: Codable>(of type: T.Type, forKey key: String) -> T? {
        let key = resolveKey(key)

        return dictionaryQueue.sync {
            dictionary[key].flatMap { $0 as? T }
        }
    }

    @discardableResult
    public func setValue<T: Codable>(_ value: T?, forKey key: String) -> Bool {
        let key = resolveKey(key)

        dictionaryQueue.async(flags: .barrier) {
            self.dictionary[key] = value
        }

        return true
    }

    @discardableResult
    public func removeValue(forKey key: String) -> Bool {
        let key = resolveKey(key)

        dictionaryQueue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }

        return true
    }

    @discardableResult
    public func clear() -> Bool {
        dictionaryQueue.async(flags: .barrier) {
            self.dictionary.removeAll()
        }

        return true
    }
}
