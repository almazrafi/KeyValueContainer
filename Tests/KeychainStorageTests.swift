import XCTest

@testable import KeyValueContainer

class KeychainStorageTests: XCTestCase {

    // MARK: - Instance Properties

    private var storage: KeychainStorage!

    // MARK: - Instance Methods

    func testThatStorageProperlyInitializesWithDefaultArguments() {
        XCTAssertTrue(storage.accessibility == .afterFirstUnlock)
        XCTAssertNil(storage.service)
        XCTAssertNil(storage.accessGroup)
        XCTAssertFalse(storage.synchronizable)
    }

    func testThatStorageProperlyInitializesWithCustomArguments() {
        let accessibility = KeychainAccessibility.whenUnlockedThisDeviceOnly
        let service = "foo"
        let accessGroup = "bar"
        let synchronizable = true

        storage = KeychainStorage(
            accessibility: accessibility,
            service: service,
            accessGroup: accessGroup,
            synchronizable: synchronizable
        )

        XCTAssertEqual(storage.accessibility, accessibility)
        XCTAssertEqual(storage.service, service)
        XCTAssertEqual(storage.accessGroup, accessGroup)
        XCTAssertEqual(storage.synchronizable, synchronizable)
    }

    func testThatStorageDoesNotProvideKeysWhenDataExists() {
        let firstKey = "foo"
        let secondKey = "bar"

        XCTAssertFalse(storage.allKeys.contains(firstKey))
        XCTAssertFalse(storage.allKeys.contains(secondKey))
    }

    func testThatStorageProvidesKeysWhenDataExists() {
        let firstKey = "foo"
        let secondKey = "bar"

        XCTAssertTrue(storage.setValue(123, forKey: firstKey))
        XCTAssertTrue(storage.setValue("qwe", forKey: secondKey))

        XCTAssertTrue(storage.allKeys.contains(firstKey))
        XCTAssertTrue(storage.allKeys.contains(secondKey))
    }

    func testThatStorageReturnsNilWhenNoDataExistsForKey() {
        XCTAssertNil(storage.value(of: Int.self, forKey: "foobar"))
    }

    func testThatStorageReturnsNilWhenIncorrectDataIsStoredForKey() {
        let key = "foobar"

        XCTAssertTrue(storage.setValue(123, forKey: key))

        XCTAssertNil(storage.value(of: CodableStruct.self, forKey: key))
    }

    func testThatStorageRemovesDataForKeyWhenValueIsSetToNil() {
        let key = "foobar"

        XCTAssertTrue(storage.setValue(123, forKey: key))
        XCTAssertTrue(storage.setValue(nil as Int?, forKey: key))

        XCTAssertNil(storage.value(of: Int.self, forKey: key))
    }

    func testThatStorageRemovesAllKeyData() {
        let firstKey = "foo"
        let secondKey = "bar"

        XCTAssertTrue(storage.setValue(123, forKey: firstKey))
        XCTAssertTrue(storage.setValue("qwe", forKey: secondKey))

        XCTAssertTrue(storage.clear())

        XCTAssertNil(storage.value(of: Int.self, forKey: firstKey))
        XCTAssertNil(storage.value(of: String.self, forKey: secondKey))
    }

    // MARK: -

    func testThatStorageProperlyStoresBooleanValues() {
        let key = "foobar"
        let value = true

        XCTAssertTrue(storage.setValue(value, forKey: key))

        XCTAssertEqual(storage.value(of: Bool.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresIntValues() {
        let key = "foobar"
        let value = 123

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: Int.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresFloatValues() {
        let key = "foobar"
        let value: Float = 1.23

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: Float.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresDoubleValues() {
        let key = "foobar"
        let value: Double = 12.3

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: Double.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresDates() {
        let key = "foobar"
        let value = Date(timeIntervalSinceReferenceDate: 123.456)

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: Date.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresRawData() {
        let key = "foobar"
        let value = Data([1, 2, 3])

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: Data.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresStrings() {
        let key = "foobar"
        let value = "qwe"

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: String.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresURLs() {
        let key = "foobar"
        let value = URL(string: "https://apple.com")!

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: URL.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresStringArrays() {
        let key = "foobar"
        let value = ["qwe", "asd", "zxc"]

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: [String].self, forKey: key), value)
    }

    func testThatStorageProperlyStoresCodablePrimitives() {
        let key = "foobar"
        let value: CGFloat = 1.23

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: CGFloat.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresCodableStructs() {
        let key = "foobar"
        let value = CodableStruct(foo: 123, bar: "qwe")

        storage.setValue(value, forKey: key)

        XCTAssertEqual(storage.value(of: CodableStruct.self, forKey: key), value)
    }

    func testThatStorageProperlyStoresMultipleValuesToSameKey() {
        let key = "foobar"
        let firstValue = true
        let secondValue = "asd"

        XCTAssertTrue(storage.setValue(firstValue, forKey: key))
        XCTAssertTrue(storage.setValue(secondValue, forKey: key))

        XCTAssertEqual(storage.value(of: String.self, forKey: key), secondValue)
    }

    // MARK: -

    func testThatStorageProperlyMakesContainersWithCustomKeyAndDefaultValue() {
        let container = storage.containerWithCustomKeyAndDefaultValue

        XCTAssertTrue(container.storage as? KeychainStorage === storage)
        XCTAssertEqual(container.key, "foobar")
        XCTAssertEqual(container.defaultValue, "qwe")
    }

    func testThatStorageProperlyMakesContainersWithPropertyNameAsKey() {
        let container = storage.containerWithPropertyNameAsKey

        XCTAssertTrue(container.storage as? KeychainStorage === storage)
        XCTAssertEqual(container.key, "containerWithPropertyNameAsKey")
        XCTAssertNil(container.defaultValue)
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        storage = KeychainStorage.default
    }

    override func tearDown() {
        super.tearDown()

        storage.clear()
    }
}

private struct CodableStruct: Codable, Equatable {

    // MARK: - Instance Properties

    let foo: Int
    let bar: String
}

private extension KeychainStorage {

    // MARK: - Instance Properties

    var containerWithCustomKeyAndDefaultValue: KeyValueContainer<String> {
        makeContainer(key: "foobar", defaultValue: "qwe")
    }

    var containerWithPropertyNameAsKey: KeyValueContainer<Int> {
        makeContainer()
    }
}
