import XCTest

@testable import KeyValueContainer

class PersistentStorageTests: XCTestCase {

    // MARK: - Instance Properties

    private var storage: PersistentStorage!

    // MARK: - Instance Methods

    func testThatStorageProperlyInitializesWithDefaultSuiteName() {
        XCTAssertTrue(storage.userDefaults === UserDefaults.standard)
        XCTAssertNil(storage.suiteName)
        XCTAssertEqual(storage.keyPrefix, "")
    }

    func testThatStorageProperlyInitializesWithCustomSuiteName() {
        let suiteName = "foo.bar"

        storage = PersistentStorage(suiteName: suiteName)

        XCTAssertEqual(storage.suiteName, suiteName)
        XCTAssertEqual(storage.keyPrefix, "")
    }

    func testThatStorageProperlyInitializesWithKeyPrefix() {
        let suiteName = "foo.bar"
        let keyPrefix = "baz"

        storage = PersistentStorage(suiteName: suiteName, keyPrefix: keyPrefix)

        XCTAssertEqual(storage.suiteName, suiteName)
        XCTAssertEqual(storage.keyPrefix, keyPrefix)
    }

    func testThatStorageReturnsNilWhenNoDataExistsForKey() {
        XCTAssertNil(storage.value(of: Int.self, forKey: "foobar"))
    }

    func testThatStorageReturnsNilWhenIncorrectDataIsStoredForKey() {
        let key = "foobar"

        storage.setValue(123, forKey: key)

        XCTAssertNil(storage.value(of: CodableStruct.self, forKey: key))
    }

    func testThatStorageRemovesDataForKeyWhenValueIsSetToNil() {
        let key = "foobar"

        storage.setValue(123, forKey: key)
        storage.setValue(nil as Int?, forKey: key)

        XCTAssertNil(storage.value(of: Int.self, forKey: key))
    }

    func testThatStorageRemovesAllKeyData() {
        let firstKey = "foo"
        let secondKey = "bar"

        storage.setValue(123, forKey: firstKey)
        storage.setValue("qwe", forKey: secondKey)

        storage.clear()

        XCTAssertNil(storage.value(of: Int.self, forKey: firstKey))
        XCTAssertNil(storage.value(of: String.self, forKey: secondKey))
    }

    // MARK: -

    func testThatStorageProperlyStoresBooleanValues() {
        let key = "foobar"
        let value = true

        storage.setValue(value, forKey: key)

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

    // MARK: -

    func testThatStorageProperlyMakesContainersWithCustomKeyAndDefaultValue() {
        let container = storage.containerWithCustomKeyAndDefaultValue

        XCTAssertTrue(container.storage as? PersistentStorage === storage)
        XCTAssertEqual(container.key, "foobar")
        XCTAssertEqual(container.defaultValue, "qwe")
    }

    func testThatStorageProperlyMakesContainersWithPropertyNameAsKey() {
        let container = storage.containerWithPropertyNameAsKey

        XCTAssertTrue(container.storage as? PersistentStorage === storage)
        XCTAssertEqual(container.key, "containerWithPropertyNameAsKey")
        XCTAssertNil(container.defaultValue)
    }

    // MARK: -

    func testThatStorageRestoresBooleanValuesStoredViaUserDefaults() {
        let key = "foobar"
        let value = true

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: Bool.self, forKey: key), value)
    }

    func testThatStorageRestoresIntValuesStoredViaUserDefaults() {
        let key = "foobar"
        let value = 123

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: Int.self, forKey: key), value)
    }

    func testThatStorageRestoresFloatValuesStoredViaUserDefaults() {
        let key = "foobar"
        let value: Float = 1.23

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: Float.self, forKey: key), value)
    }

    func testThatStorageRestoresDoubleValuesStoredViaUserDefaults() {
        let key = "foobar"
        let value: Double = 12.3

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: Double.self, forKey: key), value)
    }

    func testThatStorageRestoresDatesStoredViaUserDefaults() {
        let key = "foobar"
        let value = Date(timeIntervalSinceReferenceDate: 123.456)

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: Date.self, forKey: key), value)
    }

    func testThatStorageRestoresRawDataStoredViaUserDefaults() {
        let key = "foobar"
        let value = Data([1, 2, 3])

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: Data.self, forKey: key), value)
    }

    func testThatStorageRestoresStringsStoredViaUserDefaults() {
        let key = "foobar"
        let value = "qwe"

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: String.self, forKey: key), value)
    }

    func testThatStorageRestoresURLsStoredViaUserDefaults() {
        let key = "foobar"
        let value = URL(string: "https://apple.com")!

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: URL.self, forKey: key), value)
    }

    func testThatStorageRestoresStringArraysStoredViaUserDefaults() {
        let key = "foobar"
        let value = ["qwe", "asd", "zxc"]

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: [String].self, forKey: key), value)
    }

    func testThatStorageRestoresCodablePrimitivesStoredViaUserDefaults() {
        let key = "foobar"
        let value: CGFloat = 1.23

        storage.userDefaults.set(value, forKey: key)

        XCTAssertEqual(storage.value(of: CGFloat.self, forKey: key), value)
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        storage = PersistentStorage.default
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

private extension PersistentStorage {

    // MARK: - Instance Properties

    var containerWithCustomKeyAndDefaultValue: KeyValueContainer<String> {
        makeContainer(key: "foobar", defaultValue: "qwe")
    }

    var containerWithPropertyNameAsKey: KeyValueContainer<Int> {
        makeContainer()
    }
}
