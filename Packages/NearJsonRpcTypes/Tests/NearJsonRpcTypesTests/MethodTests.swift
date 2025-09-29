import XCTest
@testable import NearJsonRpcTypes

/// Tests for RPC method definitions, enums, and path mappings
/// Validates that generated method definitions are correct, complete, and properly mapped
class MethodTests: XCTestCase {
    
    // MARK: - RpcMethod Enum Tests
    
    func testRpcMethodEnumCompleteness() {
        let allMethods = RpcMethod.allCases
        
        // Should have reasonable number of methods (range-based testing)
        XCTAssertGreaterThan(allMethods.count, 25, "Should have at least 25 RPC methods")
        XCTAssertLessThan(allMethods.count, 50, "Should not exceed 50 RPC methods")
        
        // Should be in expected range for NEAR API
        XCTAssertTrue(allMethods.count >= 25 && allMethods.count <= 50, 
                    "Method count should be between 25-50, got \(allMethods.count)")
        
        print("RpcMethod enum has \(allMethods.count) methods")
    }
    
    func testRpcMethodRawValues() {
        // Test that all RpcMethod cases have valid raw values
        for method in RpcMethod.allCases {
            // Raw value should not be empty
            XCTAssertFalse(method.rawValue.isEmpty, "Method \(method) should have non-empty raw value")
            
            // Raw value should be valid method name (alphanumeric + underscore)
            let validPattern = "^[a-zA-Z][a-zA-Z0-9_]*$"
            let regex = try! NSRegularExpression(pattern: validPattern)
            let range = NSRange(location: 0, length: method.rawValue.count)
            let matches = regex.numberOfMatches(in: method.rawValue, range: range)
            
            XCTAssertEqual(matches, 1, "Method \(method.rawValue) should match valid naming pattern")
        }
    }
    
    func testRpcMethodCaseIterable() {
        // Test that CaseIterable is working correctly
        let allMethods = RpcMethod.allCases
        let allMethodsSet = Set(allMethods)
        
        // Should not have duplicates
        XCTAssertEqual(allMethods.count, allMethodsSet.count, 
                     "RpcMethod.allCases should not contain duplicates")
        
        // allMethods static property should match allCases
        let staticMethods = RpcMethod.allMethods
        XCTAssertEqual(allMethods.map { $0.rawValue }.sorted(), staticMethods.sorted(),
                     "allMethods static property should match allCases raw values")
    }
    
    func testRpcMethodStringConversion() {
        // Test that we can convert between strings and enum cases
        for method in RpcMethod.allCases {
            let rawValue = method.rawValue
            
            // Should be able to create enum from raw value
            let reconstructed = RpcMethod(rawValue: rawValue)
            XCTAssertNotNil(reconstructed, "Should be able to create \(rawValue) from raw value")
            XCTAssertEqual(reconstructed, method, "Reconstructed method should equal original")
        }
    }
    
    // MARK: - Path Mapping Tests
    
    func testPathToMethodMapCompleteness() {
        let methodCount = RpcMethod.allCases.count
        let pathMapCount = PATH_TO_METHOD_MAP.count
        
        // Method count should match path mapping count
        XCTAssertEqual(methodCount, pathMapCount, 
                     "RPC method count (\(methodCount)) should match PATH_TO_METHOD_MAP count (\(pathMapCount))")
        
        print("PATH_TO_METHOD_MAP has \(pathMapCount) mappings")
    }
    
    func testPathToMethodMapAccuracy() {
        // Test that all methods in the enum have corresponding paths
        for method in RpcMethod.allCases {
            let methodName = method.rawValue
            let hasPath = PATH_TO_METHOD_MAP.values.contains(methodName)
            
            XCTAssertTrue(hasPath, "Method '\(methodName)' should have corresponding path in PATH_TO_METHOD_MAP")
        }
    }
    
    func testBidirectionalMapping() {
        // Test that every path maps to a valid method, and every method has a path
        
        // Every path should map to a valid method
        for (path, methodName) in PATH_TO_METHOD_MAP {
            let method = RpcMethod(rawValue: methodName)
            XCTAssertNotNil(method, "Path '\(path)' maps to invalid method '\(methodName)'")
        }
        
        // Every method should have exactly one path
        let methodsFromPaths = Set(PATH_TO_METHOD_MAP.values)
        let methodsFromEnum = Set(RpcMethod.allCases.map { $0.rawValue })
        
        XCTAssertEqual(methodsFromPaths, methodsFromEnum, 
                     "Methods in PATH_TO_METHOD_MAP should exactly match RpcMethod enum cases")
    }
    
    func testPathFormatValidation() {
        // Test that all paths follow the expected format
        for (path, methodName) in PATH_TO_METHOD_MAP {
            // Path should start with "/"
            XCTAssertTrue(path.hasPrefix("/"), "Path '\(path)' should start with '/'")
            
            // Path should not be just "/"
            XCTAssertGreaterThan(path.count, 1, "Path '\(path)' should have content after '/'")
            
            // Path should not end with "/"
            XCTAssertFalse(path.hasSuffix("/") && path.count > 1, "Path '\(path)' should not end with '/'")
            
            // Path should generally match method name (with leading "/")
            let expectedPath = "/\(methodName)"
            XCTAssertEqual(path, expectedPath, 
                         "Path '\(path)' should match expected format '\(expectedPath)'")
        }
    }
    
    // MARK: - Method Category Tests
    
    func testCoreMethodsExist() {
        // Test that essential NEAR RPC methods exist
        let coreMethodNames = ["block", "status", "health", "query", "tx"]
        
        for methodName in coreMethodNames {
            let method = RpcMethod(rawValue: methodName)
            XCTAssertNotNil(method, "Core method '\(methodName)' should exist in RpcMethod enum")
            
            // Also check it exists in allCases
            let existsInAllCases = RpcMethod.allCases.contains { $0.rawValue == methodName }
            XCTAssertTrue(existsInAllCases, "Core method '\(methodName)' should be in RpcMethod.allCases")
        }
    }
    
    func testExperimentalMethodsMarked() {
        // Test that experimental methods are properly prefixed
        let experimentalMethods = RpcMethod.allCases.filter { 
            $0.rawValue.hasPrefix("EXPERIMENTAL_") 
        }
        
        // Should have some experimental methods (but not too many)
        XCTAssertGreaterThan(experimentalMethods.count, 5, 
                           "Should have at least some experimental methods")
        XCTAssertLessThan(experimentalMethods.count, 20, 
                        "Should not have too many experimental methods")
        
        print("Found \(experimentalMethods.count) experimental methods")
        
        // All experimental methods should follow naming convention
        for method in experimentalMethods {
            XCTAssertTrue(method.rawValue.hasPrefix("EXPERIMENTAL_"),
                        "Experimental method \(method.rawValue) should start with 'EXPERIMENTAL_'")
            
            // Should have content after the prefix
            XCTAssertGreaterThan(method.rawValue.count, "EXPERIMENTAL_".count,
                               "Experimental method \(method.rawValue) should have content after prefix")
        }
    }
    
    func testMethodNamingConsistency() {
        // Test that method names follow consistent patterns
        for method in RpcMethod.allCases {
            let methodName = method.rawValue
            
            // Should not contain spaces
            XCTAssertFalse(methodName.contains(" "), 
                         "Method '\(methodName)' should not contain spaces")
            
            // Should not contain special characters (except underscore)
            let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
            let methodCharacters = CharacterSet(charactersIn: methodName)
            XCTAssertTrue(allowedCharacters.isSuperset(of: methodCharacters),
                        "Method '\(methodName)' should only contain alphanumeric characters and underscores")
            
            // Should not start with underscore
            XCTAssertFalse(methodName.hasPrefix("_"), 
                         "Method '\(methodName)' should not start with underscore")
            
            // Should not end with underscore
            XCTAssertFalse(methodName.hasSuffix("_"), 
                         "Method '\(methodName)' should not end with underscore")
        }
    }
    
    // MARK: - API Evolution Tests
    
    func testMethodCountInReasonableRange() {
        let methodCount = RpcMethod.allCases.count
        
        // Test against expected ranges based on current NEAR API
        XCTAssertGreaterThanOrEqual(methodCount, 25, 
                                  "Method count should not drop below 25 (regression check)")
        XCTAssertLessThanOrEqual(methodCount, 50, 
                               "Method count should not exceed 50 (sanity check)")
        
        // Test ratio of core vs experimental methods
        let coreMethodCount = RpcMethod.allCases.filter { 
            !$0.rawValue.hasPrefix("EXPERIMENTAL_") 
        }.count
        let experimentalCount = methodCount - coreMethodCount
        
        // Should have more core methods than experimental
        XCTAssertGreaterThan(coreMethodCount, experimentalCount,
                           "Should have more core methods (\(coreMethodCount)) than experimental (\(experimentalCount))")
    }
    
    func testNoOrphanedEntries() {
        // Test that there are no orphaned methods or paths
        
        // No methods without paths
        for method in RpcMethod.allCases {
            let hasPath = PATH_TO_METHOD_MAP.values.contains(method.rawValue)
            XCTAssertTrue(hasPath, "Method '\(method.rawValue)' is orphaned (no corresponding path)")
        }
        
        // No paths without methods
        for (path, methodName) in PATH_TO_METHOD_MAP {
            let method = RpcMethod(rawValue: methodName)
            XCTAssertNotNil(method, "Path '\(path)' is orphaned (maps to non-existent method '\(methodName)')")
        }
        
        // Counts should match exactly
        let uniqueMethods = Set(RpcMethod.allCases.map { $0.rawValue })
        let uniquePathMethods = Set(PATH_TO_METHOD_MAP.values)
        
        XCTAssertEqual(uniqueMethods, uniquePathMethods, 
                     "Methods and path mappings should be exactly equivalent")
    }
    
    // MARK: - Integration Tests
    
    func testMethodEnumIntegration() {
        // Test that the enum integrates properly with the overall system
        
        // Should be able to iterate over all methods
        var methodCount = 0
        for _ in RpcMethod.allCases {
            methodCount += 1
        }
        XCTAssertEqual(methodCount, RpcMethod.allCases.count, 
                     "Should be able to iterate over all RpcMethod cases")
        
        // Should be able to use methods in collections
        let methodSet = Set(RpcMethod.allCases)
        let methodArray = Array(RpcMethod.allCases)
        
        XCTAssertEqual(methodSet.count, methodArray.count, 
                     "Methods should work properly in Set (no duplicates)")
    }
    
    func testPathMappingIntegration() {
        // Test that path mapping integrates with method enum
        
        // Should be able to look up any method's path
        for method in RpcMethod.allCases {
            let methodName = method.rawValue
            let path = PATH_TO_METHOD_MAP.first { $0.value == methodName }?.key
            
            XCTAssertNotNil(path, "Should be able to find path for method '\(methodName)'")
            
            if let path = path {
                XCTAssertEqual(path, "/\(methodName)", 
                             "Path for '\(methodName)' should follow expected format")
            }
        }
    }
    
    // MARK: - Performance Tests
    
    func testMethodLookupPerformance() {
        // Test performance of method operations
        measure {
            // Perform method lookups and conversions
            for _ in 0..<1000 {
                // Test enum case access
                let _ = RpcMethod.allCases
                
                // Test raw value conversion
                for method in RpcMethod.allCases.prefix(10) {
                    let _ = RpcMethod(rawValue: method.rawValue)
                }
                
                // Test path lookup
                let _ = PATH_TO_METHOD_MAP["block"]
            }
        }
    }
}
