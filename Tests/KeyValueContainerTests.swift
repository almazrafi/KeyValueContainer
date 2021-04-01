import XCTest

@testable import KeyValueContainer

struct UnusedStruct { }

class KeyValueContainerTests: XCTestCase {

    // MARK: - Instance Properties

    private var storage: MockKeyValueStorage!
    private var container: KeyValueContainer<String>!

    // MARK: - Instance Methods

    func testThatContainerProperlyInitializes() {
        XCTAssertTrue(container.storage as? MockKeyValueStorage === storage)
        XCTAssertEqual(container.key, "foobar")
    }

    func testThatContainerProperlyRestoresValueFromStorage() {
        storage.valueStub = "qwe"

        XCTAssertEqual(container.value, "qwe")
        XCTAssertEqual(storage.valueCallCount, 1)
        XCTAssertTrue(storage.valueLastArguments?.type is String.Type)
        XCTAssertEqual(storage.valueLastArguments?.key, "foobar")
    }

    func testThatContainerProperlyStoresValueInStorage() {
        container.value = "qwe"

        XCTAssertEqual(storage.setValueCallCount, 1)
        XCTAssertEqual(storage.setValueLastArguments?.value as? String, "qwe")
        XCTAssertEqual(storage.setValueLastArguments?.key, "foobar")
    }

    func testThatContainerReturnsDefaultValueWhenNoDataExistsForKeyInStorage() {
        storage.valueStub = nil

        XCTAssertEqual(container.value, "asd")
        XCTAssertEqual(storage.valueCallCount, 1)
        XCTAssertTrue(storage.valueLastArguments?.type is String.Type)
        XCTAssertEqual(storage.valueLastArguments?.key, "foobar")
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        storage = MockKeyValueStorage()
        container = KeyValueContainer<String>(storage: storage, key: "foobar", defaultValue: "asd")
    }
}
