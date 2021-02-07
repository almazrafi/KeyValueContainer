import Foundation

public final class PersistentStorage: KeyValueStorage {

    // MARK: - Type Properties

    public static let `default` = PersistentStorage(
        userDefaults: .standard,
        suiteName: nil,
        keyPrefix: ""
    )

    // MARK: - Instance Properties

    internal let userDefaults: UserDefaults

    public let suiteName: String?
    public let keyPrefix: String

    // MARK: - Initializers

    private init(userDefaults: UserDefaults, suiteName: String?, keyPrefix: String) {
        self.userDefaults = userDefaults

        self.suiteName = suiteName
        self.keyPrefix = keyPrefix

        print(suiteName)
    }

    public convenience init?(suiteName: String?, keyPrefix: String = "") {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            return nil
        }

        self.init(
            userDefaults: userDefaults,
            suiteName: suiteName,
            keyPrefix: keyPrefix
        )
    }

    // MARK: - Instance Methods

    private func resolveKey(_ key: String) -> String {
        return keyPrefix.appending(key)
    }

    public func value<T: Codable>(of type: T.Type, forKey key: String) -> T? {
        let key = resolveKey(key)

        guard let storageValue = userDefaults.object(forKey: key) else {
            return nil
        }

        switch T.self {
        case is Bool.Type:
            return userDefaults.bool(forKey: key) as? T

        case is Int.Type:
            return userDefaults.integer(forKey: key) as? T

        case is Float.Type:
            return userDefaults.float(forKey: key) as? T

        case is Double.Type:
            return userDefaults.double(forKey: key) as? T

        case is Date.Type:
            return userDefaults.object(forKey: key) as? T

        case is String.Type:
            return userDefaults.string(forKey: key) as? T

        case is Data.Type:
            return userDefaults.data(forKey: key) as? T

        case is URL.Type:
            return userDefaults.url(forKey: key) as? T

        case is [String].Type:
            return userDefaults.stringArray(forKey: key) as? T

        default:
            let propertyListData = try? PropertyListSerialization.data(
                fromPropertyList: storageValue,
                format: .binary,
                options: 0
            )

            return propertyListData.flatMap { data in
                try? PropertyListDecoder().decode(T.self, from: data)
            }
        }
    }

    public func setValue<T: Codable>(_ value: T?, forKey key: String) {
        let key = resolveKey(key)

        switch value {
        case let bool as Bool:
            userDefaults.set(bool, forKey: key)

        case let integer as Int:
            userDefaults.set(integer, forKey: key)

        case let float as Float:
            userDefaults.set(float, forKey: key)

        case let double as Double:
            userDefaults.set(double, forKey: key)

        case let date as Date:
            userDefaults.set(date, forKey: key)

        case let string as String:
            userDefaults.set(string, forKey: key)

        case let data as Data:
            userDefaults.set(data, forKey: key)

        case let url as URL:
            userDefaults.set(url, forKey: key)

        case let stringArray as [String]:
            userDefaults.set(stringArray, forKey: key)

        default:
            let propertyList = value
                .flatMap { try? PropertyListEncoder().encode([$0]) }
                .flatMap { data in
                    try? PropertyListSerialization.propertyList(
                        from: data,
                        options: [],
                        format: nil
                    )
                }

            let storageValue = propertyList
                .flatMap { $0 as? [Any] }?
                .first

            userDefaults.set(storageValue, forKey: key)
        }
    }

    public func clear() {
        let dictionaryRepresentation = userDefaults.dictionaryRepresentation()

        dictionaryRepresentation.keys.forEach { key in
            if key.hasPrefix(keyPrefix) {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}
