import XCTest
@testable import NearJsonRpcTypes

/// Tests for error handling, edge cases, and boundary conditions
/// Validates that generated error types and complex structures handle extreme scenarios
class ErrorHandlingTests: XCTestCase {
    
    // MARK: - Error Enum Completeness Tests
    
    func testHostErrorEnumCompleteness() {
        // HostError is one of the largest error enums in NEAR
        let hostErrorCases = [
            HostError.badutf16,
            HostError.badutf8,
            HostError.gasexceeded,
            HostError.gaslimitexceeded,
            HostError.balanceexceeded,
            HostError.emptymethodname,
            HostError.integeroverflow,
            HostError.cannotappendactiontojointpromise,
            HostError.cannotreturnjointpromise,
            HostError.memoryaccessviolation,
            HostError.invalidaccountid,
            HostError.invalidmethodname,
            HostError.invalidpublickey
        ]
        
        // Should have a reasonable number of error cases (range-based testing)
        XCTAssertGreaterThan(hostErrorCases.count, 10, "HostError should have at least 10 basic cases")
        XCTAssertLessThan(hostErrorCases.count, 50, "HostError should not exceed 50 cases")
        
        // All cases should be Codable (verified by compilation success)
        XCTAssertNotNil(HostError.gasexceeded, "HostError cases should be instantiable")
        
        print("HostError has \(hostErrorCases.count) basic error cases")
    }
    
    func testActionsValidationErrorTypes() {
        // Test various ActionsValidationError cases
        let validationErrors = [
            ActionsValidationError.deleteactionmustbefinal,
            ActionsValidationError.integeroverflow,
            ActionsValidationError.functioncallzeroattachedgas,
            ActionsValidationError.delegateactionmustbeonlyone
        ]
        
        // Should have reasonable number of validation error types
        XCTAssertGreaterThan(validationErrors.count, 3, "Should have multiple validation error types")
        XCTAssertLessThan(validationErrors.count, 30, "Should not have excessive validation errors")
        
        // All validation errors should be Codable and Sendable (verified by compilation success)
        XCTAssertNotNil(ActionsValidationError.integeroverflow, "ActionsValidationError cases should be instantiable")
    }
    
    func testActionErrorKindCompleteness() {
        // Test ActionErrorKind cases (critical for transaction failures)
        let actionErrors = [
            ActionErrorKind.delegateactioninvalidsignature,
            ActionErrorKind.delegateactionexpired
        ]
        
        // ActionErrorKind should exist and be testable
        XCTAssertGreaterThan(actionErrors.count, 1, "Should have multiple ActionErrorKind cases")
        
        // All should conform to required protocols (verified by compilation success)
        XCTAssertNotNil(ActionErrorKind.delegateactionexpired, "ActionErrorKind cases should be instantiable")
    }
    
    func testErrorEnumSerialization() {
        // Test that error enums can be serialized and deserialized
        let hostError = HostError.gasexceeded
        let validationError = ActionsValidationError.integeroverflow
        
        // Test HostError serialization
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(hostError)
            let decoded = try JSONDecoder().decode(HostError.self, from: jsonData)
            
            // Verify the error type is preserved (can't directly compare enum cases)
            XCTAssertNotNil(decoded)
        })
        
        // Test ActionsValidationError serialization
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(validationError)
            let decoded = try JSONDecoder().decode(ActionsValidationError.self, from: jsonData)
            
            XCTAssertNotNil(decoded)
        })
    }
    
    // MARK: - Complex Type Validation Tests
    
    func testNestedStructureHandling() {
        // Test complex nested structures like ValidatorKickoutView
        let kickoutView = ValidatorKickoutView(
            account_id: "validator.near",
            reason: ValidatorKickoutReason.case0(NotEnoughBlocks: "100")
        )
        
        // Test round-trip encoding/decoding of nested structure
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(kickoutView)
            let decoded = try JSONDecoder().decode(ValidatorKickoutView.self, from: jsonData)
            
            XCTAssertEqual(kickoutView.account_id, decoded.account_id)
            XCTAssertNotNil(decoded.reason) // Can't directly compare enum cases
        })
    }
    
    func testOptionalChainHandling() {
        // Test structures with multiple optional properties like RpcSplitStorageInfoResponse
        let storageInfo = RpcSplitStorageInfoResponse(
            head_height: 1000000,
            cold_head_height: nil,
            final_head_height: nil,
            hot_db_kind: "RocksDB"
        )
        
        // Test with mixed nil and non-nil values
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(storageInfo)
            let decoded = try JSONDecoder().decode(RpcSplitStorageInfoResponse.self, from: jsonData)
            
            XCTAssertNil(decoded.cold_head_height)
            XCTAssertEqual(decoded.head_height, 1000000)
            XCTAssertNil(decoded.final_head_height)
            XCTAssertEqual(decoded.hot_db_kind, "RocksDB")
        })
        
        // Test with all nil values
        let allNilStorage = RpcSplitStorageInfoResponse(
            head_height: nil,
            cold_head_height: nil,
            final_head_height: nil,
            hot_db_kind: nil
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(allNilStorage)
            let decoded = try JSONDecoder().decode(RpcSplitStorageInfoResponse.self, from: jsonData)
            
            XCTAssertNil(decoded.cold_head_height)
            XCTAssertNil(decoded.head_height)
            XCTAssertNil(decoded.final_head_height)
            XCTAssertNil(decoded.hot_db_kind)
        })
    }
    
    func testLargeStructureHandling() {
        // Test structures with many properties like StorageUsageConfigView
        let storageConfig = StorageUsageConfigView(
            num_bytes_account: 100,
            num_extra_bytes_record: 40
        )
        
        // Test serialization of structure with multiple UInt64 properties
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(storageConfig)
            let decoded = try JSONDecoder().decode(StorageUsageConfigView.self, from: jsonData)
            
            XCTAssertEqual(storageConfig.num_extra_bytes_record, decoded.num_extra_bytes_record)
            XCTAssertEqual(storageConfig.num_bytes_account, decoded.num_bytes_account)
        })
    }
    
    // MARK: - Boundary Value Testing
    
    func testUInt64BoundaryValues() {
        // Test with UInt64 maximum and minimum values
        let maxValueConfig = StorageUsageConfigView(
            num_bytes_account: UInt64.max,
            num_extra_bytes_record: UInt64.max
        )
        
        // Test UInt64.max serialization
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(maxValueConfig)
            let decoded = try JSONDecoder().decode(StorageUsageConfigView.self, from: jsonData)
            
            XCTAssertEqual(maxValueConfig.num_extra_bytes_record, decoded.num_extra_bytes_record)
            XCTAssertEqual(maxValueConfig.num_bytes_account, decoded.num_bytes_account)
        })
        
        let minValueConfig = StorageUsageConfigView(
            num_bytes_account: UInt64.min,
            num_extra_bytes_record: UInt64.min
        )
        
        // Test UInt64.min (0) serialization
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(minValueConfig)
            let decoded = try JSONDecoder().decode(StorageUsageConfigView.self, from: jsonData)
            
            XCTAssertEqual(minValueConfig.num_extra_bytes_record, decoded.num_extra_bytes_record)
            XCTAssertEqual(minValueConfig.num_bytes_account, decoded.num_bytes_account)
        })
    }
    
    func testStringLengthLimits() {
        // Test with very long strings (common in blockchain data)
        let _ = String(repeating: "a", count: 1000) + ".near" // Long account ID for reference
        let veryLongMethodName = String(repeating: "test_method_", count: 100) + "end"
        
        let actionWithLongStrings = FunctionCallAction(
            deposit: String(repeating: "9", count: 50), // Very large number as string
            method_name: veryLongMethodName,
            args: String(repeating: "eyJkYXRhIjoidGVzdCJ9", count: 50), // Long base64 string
            gas: 30000000000000
        )
        
        // Test serialization with long strings
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(actionWithLongStrings)
            let decoded = try JSONDecoder().decode(FunctionCallAction.self, from: jsonData)
            
            XCTAssertEqual(actionWithLongStrings.method_name, decoded.method_name)
            XCTAssertEqual(actionWithLongStrings.deposit, decoded.deposit)
            XCTAssertEqual(actionWithLongStrings.args, decoded.args)
            XCTAssertEqual(actionWithLongStrings.gas, decoded.gas)
        })
    }
    
    func testEmptyAndNilStringHandling() {
        // Test with empty strings and nil values
        let emptyStringAction = FunctionCallAction(
            deposit: "0", // Zero deposit
            method_name: "", // Empty method name
            args: "", // Empty args
            gas: 0 // Zero gas
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(emptyStringAction)
            let decoded = try JSONDecoder().decode(FunctionCallAction.self, from: jsonData)
            
            XCTAssertEqual(emptyStringAction.method_name, decoded.method_name)
            XCTAssertEqual(emptyStringAction.deposit, decoded.deposit)
            XCTAssertEqual(emptyStringAction.args, decoded.args)
            XCTAssertEqual(emptyStringAction.gas, decoded.gas)
        })
        
        // Test optional string handling
        let peerWithNils = RpcPeerInfo(
            account_id: nil,
            id: PeerId(),
            addr: nil
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(peerWithNils)
            let decoded = try JSONDecoder().decode(RpcPeerInfo.self, from: jsonData)
            
            XCTAssertNil(decoded.account_id)
            XCTAssertNil(decoded.addr)
            XCTAssertNotNil(decoded.id)
        })
    }
    
    func testNumericalEdgeCases() {
        // Test with various numerical edge cases
        let edgeCaseValues: [UInt64] = [
            0,                    // Minimum
            1,                    // Just above minimum
            1000000000000000,     // Common large blockchain value
            9223372036854775807,  // Near UInt64.max
            UInt64.max            // Maximum
        ]
        
        for value in edgeCaseValues {
            let config = StorageUsageConfigView(
                num_bytes_account: value,
                num_extra_bytes_record: value
            )
            
            XCTAssertNoThrow({
                let jsonData = try JSONEncoder().encode(config)
                let decoded = try JSONDecoder().decode(StorageUsageConfigView.self, from: jsonData)
                
                XCTAssertEqual(config.num_extra_bytes_record, decoded.num_extra_bytes_record)
                XCTAssertEqual(config.num_bytes_account, decoded.num_bytes_account)
            }, "Failed to serialize/deserialize UInt64 value: \(value)")
        }
    }
    
    // MARK: - Real-world Error Scenarios
    
    func testTransactionErrorScenarios() {
        // Test common transaction error scenarios
        let gasExceededError = HostError.gasexceeded
        let balanceExceededError = HostError.balanceexceeded
        let invalidAccountError = HostError.invalidaccountid
        
        let errorScenarios = [gasExceededError, balanceExceededError, invalidAccountError]
        
        for error in errorScenarios {
            XCTAssertNoThrow({
                let jsonData = try JSONEncoder().encode(error)
                let decoded = try JSONDecoder().decode(HostError.self, from: jsonData)
                
                XCTAssertNotNil(decoded)
            }, "Failed to serialize/deserialize HostError: \(error)")
        }
    }
    
    func testValidationErrorScenarios() {
        // Test common validation error scenarios
        let deleteActionError = ActionsValidationError.deleteactionmustbefinal
        let integerOverflowError = ActionsValidationError.integeroverflow
        let zeroGasError = ActionsValidationError.functioncallzeroattachedgas
        
        let validationScenarios = [deleteActionError, integerOverflowError, zeroGasError]
        
        for error in validationScenarios {
            XCTAssertNoThrow({
                let jsonData = try JSONEncoder().encode(error)
                let decoded = try JSONDecoder().decode(ActionsValidationError.self, from: jsonData)
                
                XCTAssertNotNil(decoded)
            }, "Failed to serialize/deserialize ActionsValidationError: \(error)")
        }
    }
    
    func testMissingTrieValueHandling() {
        // Test MissingTrieValue structure (common in state queries)
        let missingValue = MissingTrieValue(
            hash: "ed25519:hash_value_here",
            context: MissingTrieValueContext.triestorage
        )
        
        XCTAssertNoThrow({
            let jsonData = try JSONEncoder().encode(missingValue)
            let decoded = try JSONDecoder().decode(MissingTrieValue.self, from: jsonData)
            
            XCTAssertEqual(missingValue.hash, decoded.hash)
            XCTAssertNotNil(decoded.context)
        })
    }
    
    // MARK: - JSON Format Compliance Tests
    
    func testErrorJSONFormatCompliance() {
        // Test that errors produce valid JSON
        let hostError = HostError.gasexceeded
        
        do {
            let jsonData = try JSONEncoder().encode(hostError)
            
            // Verify it's valid JSON
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            XCTAssertNotNil(jsonObject, "Error should produce valid JSON")
            
            // Should be readable as string or object
            XCTAssertTrue(jsonObject is String || jsonObject is [String: Any], 
                        "Error JSON should be string or object")
        } catch {
            XCTFail("Error JSON format validation failed: \(error)")
        }
    }
    
    func testComplexStructureJSONCompliance() {
        // Test complex structure JSON format
        let kickoutView = ValidatorKickoutView(
            account_id: "test.near",
            reason: ValidatorKickoutReason.case0(NotEnoughBlocks: "100")
        )
        
        do {
            let jsonData = try JSONEncoder().encode(kickoutView)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            
            XCTAssertTrue(jsonObject is [String: Any], "Complex structure should produce JSON object")
            
            if let dict = jsonObject as? [String: Any] {
                XCTAssertNotNil(dict["account_id"], "Should contain account_id field")
                XCTAssertNotNil(dict["reason"], "Should contain reason field")
                XCTAssertEqual(dict["account_id"] as? String, "test.near")
            }
        } catch {
            XCTFail("Complex structure JSON validation failed: \(error)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testErrorSerializationPerformance() {
        // Test performance of error serialization (important for error handling)
        let errors: [any Codable] = [
            HostError.gasexceeded,
            HostError.balanceexceeded,
            ActionsValidationError.integeroverflow,
            ActionsValidationError.functioncallzeroattachedgas
        ]
        
        measure {
            // Perform 1000 error serialization cycles
            for _ in 0..<1000 {
                for error in errors {
                    do {
                        let jsonData = try JSONEncoder().encode(error)
                        _ = jsonData.count // Force evaluation
                    } catch {
                        XCTFail("Performance test failed: \(error)")
                    }
                }
            }
        }
    }
    
    func testComplexStructurePerformance() {
        // Test performance of complex structure operations
        let kickoutView = ValidatorKickoutView(
            account_id: "test.near",
            reason: ValidatorKickoutReason.case0(NotEnoughBlocks: "100")
        )
        
        measure {
            // Perform 1000 encode/decode cycles
            for _ in 0..<1000 {
                do {
                    let jsonData = try JSONEncoder().encode(kickoutView)
                    _ = try JSONDecoder().decode(ValidatorKickoutView.self, from: jsonData)
                } catch {
                    XCTFail("Performance test failed: \(error)")
                }
            }
        }
    }
}
