import Foundation
import KeyValueContainer

class MockKeyValueStorage: KeyValueStorage {

    // MARK: - Instance Properties

    private(set) var valueCallCount = 0
    private(set) var valueLastArguments: (type: Any.Type, key: String?)?

    var valueStub: Any?

    private(set) var setValueCallCount = 0
    private(set) var setValueLastArguments: (value: Any?, key: String)?

    var setValueStub = true

    // MARK: - Instance Methods

    func value<T: Codable>(of type: T.Type, forKey key: String) -> T? {
        valueCallCount += 1
        valueLastArguments = (type: type, key: key)

        return valueStub as? T
    }

    @discardableResult
    func setValue<T: Codable>(_ value: T?, forKey key: String) -> Bool {
        setValueCallCount += 1
        setValueLastArguments = (value: value, key: key)

        return setValueStub
    }
}
