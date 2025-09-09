import XCTest
@testable import NearJsonRpcTypes

final class NearJsonRpcTypesTests: XCTestCase {
    func testPackageInitialization() throws {
        let types = NearJsonRpcTypes()
        XCTAssertNotNil(types)
    }
    
    func testVersion() throws {
        XCTAssertFalse(NearJsonRpcTypes.version.isEmpty)
        XCTAssertTrue(NearJsonRpcTypes.version.contains("."))
    }
}
