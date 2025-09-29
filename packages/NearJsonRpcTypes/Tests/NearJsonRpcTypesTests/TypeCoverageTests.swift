import XCTest
@testable import NearJsonRpcTypes

/// Tests for type coverage and system integrity
/// Verifies that the generated types package has the expected structure and content
class TypeCoverageTests: XCTestCase {
    
    func testMethodCount() {
        let methodCount = RpcMethod.allCases.count
        print("Debug: Found \(methodCount) RPC methods")
        
        // Should have reasonable number of RPC methods (range-based testing)
        XCTAssertGreaterThan(methodCount, 25, "Should have at least 25 RPC methods")
        XCTAssertLessThan(methodCount, 50, "Should not exceed 50 RPC methods")
    }
    
    func testPathToMethodMapping() {
        let methodCount = RpcMethod.allCases.count
        let pathMapCount = PATH_TO_METHOD_MAP.count
        
        print("Debug: Methods=\(methodCount), PathMappings=\(pathMapCount)")
        
        // Method count should match path mapping count
        XCTAssertEqual(methodCount, pathMapCount, 
                     "RPC method count (\(methodCount)) should match PATH_TO_METHOD_MAP count (\(pathMapCount))")
    }
    
    func testKeyMethodsExist() {
        // Test that core methods exist
        let expectedMethods = ["block", "status", "health", "query", "tx"]
        
        for method in expectedMethods {
            let hasMethod = RpcMethod.allCases.contains { $0.rawValue == method }
            XCTAssertTrue(hasMethod, "Should contain core method: \(method)")
        }
    }
    
    func testMethodsHaveValidPaths() {
        // All methods should have corresponding paths
        for method in RpcMethod.allCases {
            let hasPath = PATH_TO_METHOD_MAP.values.contains(method.rawValue)
            XCTAssertTrue(hasPath, "Method \(method.rawValue) should have corresponding path")
        }
    }
}
