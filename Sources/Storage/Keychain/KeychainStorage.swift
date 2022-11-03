import Foundation

public final class KeychainStorage: KeyValueStorage {

    // MARK: - Type Properties

    public static let `default` = KeychainStorage()

    // MARK: - Instance Properties

    public let accessibility: KeychainAccessibility
    public let service: String?
    public let accessGroup: String?
    public let synchronizable: Bool

    public var allKeys: [String] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: resolveService(),
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]

        if let accessGroup = self.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }

        var result: AnyObject?

        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess else {
            return []
        }

        return result
            .flatMap { $0 as? [[String: Any]] }?
            .compactMap { $0[kSecAttrAccount as String] as? Data }
            .compactMap { String(data: $0, encoding: .utf8) } ?? []
    }

    // MARK: - Initializers

    public init(
        accessibility: KeychainAccessibility = .afterFirstUnlock,
        service: String? = nil,
        accessGroup: String? = nil,
        synchronizable: Bool = false
    ) {
        self.accessibility = accessibility
        self.service = service
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }

    private func resolveAccessibility() -> String {
        switch accessibility {
        case .afterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock as String

        case .afterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String

        case .whenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String

        case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked as String

        case .whenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
        }
    }

    private func resolveService() -> String {
        service ?? Bundle.main.bundleIdentifier ?? "\(Self.self)"
    }

    private func resolveQuery(forKey key: String) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccessible as String: resolveAccessibility(),
            kSecAttrService as String: resolveService()
        ]

        if let accessGroup = self.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }

        let encodedIdentifier = key.data(using: String.Encoding.utf8)

        query[kSecAttrGeneric as String] = encodedIdentifier
        query[kSecAttrAccount as String] = encodedIdentifier

        query[kSecAttrSynchronizable as String] = synchronizable

        return query
    }

    public func value<T: Codable>(of type: T.Type, forKey key: String) -> T? {
        var query = resolveQuery(forKey: key)

        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true

        var result: AnyObject?

        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess else {
            return nil
        }

        guard let storageData = result as? Data else {
            return nil
        }

        switch T.self {
        case is String.Type:
            return String(data: storageData, encoding: .utf8) as? T

        case is Data.Type:
            return storageData as? T

        default:
            return try? JSONDecoder()
                .decode([T].self, from: storageData)
                .first
        }
    }

    @discardableResult
    public func setValue<T: Codable>(_ value: T?, forKey key: String) -> Bool {
        let storageData: Data?

        switch value {
        case nil:
            return removeValue(forKey: key)

        case let string as String:
            storageData = string.data(using: .utf8)

        case let data as Data:
            storageData = data

        default:
            storageData = try? value.flatMap { value in
                try JSONEncoder().encode([value])
            }
        }

        guard let storageData = storageData else {
            return false
        }

        let query = resolveQuery(forKey: key)
        let attributes = [kSecValueData as String: storageData]

        switch SecItemAdd(query.merging(attributes) { $1 } as CFDictionary, nil) {
        case errSecSuccess:
            return true

        case errSecDuplicateItem:
            guard SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess else {
                return false
            }

            return true

        default:
            return false
        }
    }

    @discardableResult
    public func removeValue(forKey key: String) -> Bool {
        let query = resolveQuery(forKey: key)

        guard SecItemDelete(query as CFDictionary) == errSecSuccess else {
            return false
        }

        return true
    }

    @discardableResult
    public func clear() -> Bool {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: resolveService()
        ]

        if let accessGroup = self.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            return false
        }

        return true
    }
}
