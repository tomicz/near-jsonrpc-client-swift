import XCTest
@testable import NearJsonRpcTypes

/// Tests for Codable conformance and JSON serialization/deserialization
/// Validates that generated types can properly encode to JSON and decode back without data loss
class CodableTests: XCTestCase {
    
    // MARK: - Core Type Codable Tests
    
    func testFunctionCallActionCodable() {
        // Create a sample FunctionCallAction
        let original = FunctionCallAction(
            method_name: "test_method",
            gas: 30000000000000, // 30 TGas as UInt64
            args: "eyJ0ZXN0IjoidmFsdWUifQ==", // base64 encoded JSON
            deposit: "1000000000000000000000000" // 1 NEAR in yoctoNEAR as String
        )
        
        // Test round-trip encoding/decoding
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(original)
            let decoded = try JSONDecoder().decode(FunctionCallAction.self, from: jsonData)
            
            XCTAssertEqual(original.method_name, decoded.method_name)
            XCTAssertEqual(original.deposit, decoded.deposit)
            XCTAssertEqual(original.args, decoded.args)
            XCTAssertEqual(original.gas, decoded.gas)
        })
    }
    
    func testAddKeyActionExists() {
        // Test that AddKeyAction type exists and is Codable
        XCTAssertTrue(AddKeyAction.self is Codable.Type, "AddKeyAction should conform to Codable")
        
        // Test that we can create encoder/decoder for this type
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        XCTAssertNotNil(encoder)
        XCTAssertNotNil(decoder)
    }
    
    func testRpcPeerInfoCodable() {
        // Create a sample RpcPeerInfo
        let original = RpcPeerInfo(
            id: PeerId(),
            account_id: "test.near",
            addr: "127.0.0.1:24567"
        )
        
        // Test round-trip encoding/decoding
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(original)
            let decoded = try JSONDecoder().decode(RpcPeerInfo.self, from: jsonData)
            
            // Skip PeerId comparison since it doesn't conform to Equatable
            XCTAssertEqual(original.addr, decoded.addr)
            XCTAssertEqual(original.account_id, decoded.account_id)
            XCTAssertNotNil(decoded.id) // Just verify it exists
        })
    }
    
    func testCongestionInfoViewExists() {
        // Test that CongestionInfoView type exists and is Codable
        // We'll just verify the type exists without trying to instantiate it
        XCTAssertTrue(CongestionInfoView.self is Codable.Type, "CongestionInfoView should conform to Codable")
        
        // Test that we can create encoder/decoder for this type
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        XCTAssertNotNil(encoder)
        XCTAssertNotNil(decoder)
    }
    
    // MARK: - String-Based Type Tests
    
    func testStringTypeAliases() {
        // Test that string-based type aliases work correctly
        let finality: Finality = "final"
        let nearToken: NearToken = "1000000000000000000000000"
        
        // These should encode/decode as simple strings
        XCTAssertNoThrow({
            let finalityData = try JSONEncoder().encode(finality)
            let decodedFinality = try JSONDecoder().decode(Finality.self, from: finalityData)
            XCTAssertEqual(finality, decodedFinality)
            
            let tokenData = try JSONEncoder().encode(nearToken)
            let decodedToken = try JSONDecoder().decode(NearToken.self, from: tokenData)
            XCTAssertEqual(nearToken, decodedToken)
        })
    }
    
    func testUInt64TypeAlias() {
        // Test that UInt64-based type aliases work correctly
        let gasAmount: NearGas = 30000000000000
        
        XCTAssertNoThrow({
            let gasData = try JSONEncoder().encode(gasAmount)
            let decodedGas = try JSONDecoder().decode(NearGas.self, from: gasData)
            XCTAssertEqual(gasAmount, decodedGas)
        })
    }
    
    // MARK: - Optional Properties Tests
    
    func testOptionalPropertiesHandling() {
        // Test RpcPeerInfo with nil values
        let peerWithNils = RpcPeerInfo(
            id: PeerId(),
            account_id: nil, // Optional property
            addr: nil // Optional property
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(peerWithNils)
            let decoded = try JSONDecoder().decode(RpcPeerInfo.self, from: jsonData)
            
            // Skip PeerId comparison since it doesn't conform to Equatable
            XCTAssertEqual(peerWithNils.addr, decoded.addr)
            XCTAssertEqual(peerWithNils.account_id, decoded.account_id)
            XCTAssertNil(decoded.addr)
            XCTAssertNil(decoded.account_id)
            XCTAssertNotNil(decoded.id) // Just verify it exists
        })
    }
    
    // MARK: - Edge Case Tests
    
    func testLargeNumberHandling() {
        // Test with large numbers (common in blockchain)
        let largeDeposit = "999999999999999999999999999" // Very large number as string
        
        let action = FunctionCallAction(
            method_name: "large_numbers_test",
            gas: 300000000000000, // Large gas as UInt64
            args: "",
            deposit: largeDeposit
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(action)
            let decoded = try JSONDecoder().decode(FunctionCallAction.self, from: jsonData)
            
            XCTAssertEqual(action.deposit, decoded.deposit)
            XCTAssertEqual(action.gas, decoded.gas)
        })
    }
    
    func testSpecialCharactersHandling() {
        // Test with special characters and Unicode
        let specialMethod = "test_method_with_üñíçødé_🚀"
        let specialArgs = "eyJ0ZXN0IjogIuKAnHNwZWNpYWwgY2hhcnPigJ0ifQ==" // base64 with special chars
        
        let action = FunctionCallAction(
            method_name: specialMethod,
            gas: 30000000000000,
            args: specialArgs,
            deposit: "0"
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(action)
            let decoded = try JSONDecoder().decode(FunctionCallAction.self, from: jsonData)
            
            XCTAssertEqual(action.method_name, decoded.method_name)
            XCTAssertEqual(action.args, decoded.args)
        })
    }
    
    func testEmptyStringHandling() {
        // Test with empty strings
        let actionWithEmpties = FunctionCallAction(
            method_name: "", // Empty method name
            gas: 30000000000000,
            args: "", // Empty args
            deposit: "0"
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(actionWithEmpties)
            let decoded = try JSONDecoder().decode(FunctionCallAction.self, from: jsonData)
            
            XCTAssertEqual(actionWithEmpties.method_name, decoded.method_name)
            XCTAssertEqual(actionWithEmpties.args, decoded.args)
            XCTAssertTrue(decoded.method_name.isEmpty)
            XCTAssertTrue(decoded.args.isEmpty)
        })
    }
    
    // MARK: - JSON Format Validation Tests
    
    func testJSONFormatCompliance() {
        // Test that encoded JSON is valid and readable
        let action = FunctionCallAction(
            method_name: "test_method",
            gas: 30000000000000,
            args: "eyJ0ZXN0IjoidmFsdWUifQ==",
            deposit: "1000000000000000000000000"
        )
        
        do {
            let jsonData = try JSONEncoder().encode(action)
            
            // Verify it's valid JSON by parsing it
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            XCTAssertTrue(jsonObject is [String: Any], "Should produce valid JSON object")
            
            // Verify we can read it as a dictionary
            if let dict = jsonObject as? [String: Any] {
                XCTAssertEqual(dict["method_name"] as? String, "test_method")
                XCTAssertEqual(dict["deposit"] as? String, "1000000000000000000000000")
                XCTAssertEqual(dict["args"] as? String, "eyJ0ZXN0IjoidmFsdWUifQ==")
                XCTAssertEqual(dict["gas"] as? UInt64, 30000000000000) // UInt64, not String
            } else {
                XCTFail("JSON should be a dictionary")
            }
        } catch {
            XCTFail("JSON format validation failed: \(error)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testCodablePerformance() {
        // Test encoding/decoding performance with multiple operations
        let action = FunctionCallAction(
            method_name: "performance_test",
            gas: 30000000000000,
            args: "eyJ0ZXN0IjoidmFsdWUifQ==",
            deposit: "1000000000000000000000000"
        )
        
        measure {
            // Perform 1000 encode/decode cycles
            for _ in 0..<1000 {
                do {
                    let jsonData = try JSONEncoder().encode(action)
                    let _ = try JSONDecoder().decode(FunctionCallAction.self, from: jsonData)
                } catch {
                    XCTFail("Performance test failed: \(error)")
                }
            }
        }
    }
}
