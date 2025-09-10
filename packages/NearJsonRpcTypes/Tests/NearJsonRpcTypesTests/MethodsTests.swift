import XCTest
@testable import NearJsonRpcTypes

final class MethodsTests: XCTestCase {
    
    // MARK: - RPC Methods Tests
    
    func testRpcMethodsArray() throws {
        XCTAssertFalse(rpcMethods.isEmpty)
        XCTAssertTrue(rpcMethods.contains("block"))
        XCTAssertTrue(rpcMethods.contains("status"))
        XCTAssertTrue(rpcMethods.contains("query"))
        XCTAssertTrue(rpcMethods.contains("validators"))
    }
    
    func testRpcMethodsAreSorted() throws {
        let sortedMethods = rpcMethods.sorted()
        XCTAssertEqual(rpcMethods, sortedMethods)
    }
    
    func testExperimentalMethods() throws {
        let experimentalMethods = RpcMethodValidator.experimentalMethods()
        XCTAssertFalse(experimentalMethods.isEmpty)
        
        for method in experimentalMethods {
            XCTAssertTrue(method.hasPrefix("EXPERIMENTAL_"))
        }
    }
    
    func testStableMethods() throws {
        let stableMethods = RpcMethodValidator.stableMethods()
        XCTAssertFalse(stableMethods.isEmpty)
        
        for method in stableMethods {
            XCTAssertFalse(method.hasPrefix("EXPERIMENTAL_"))
        }
    }
    
    // MARK: - Path to Method Mapping Tests
    
    func testPathToMethodMap() throws {
        XCTAssertFalse(pathToMethodMap.isEmpty)
        XCTAssertEqual(pathToMethodMap["/block"], "block")
        XCTAssertEqual(pathToMethodMap["/status"], "status")
        XCTAssertEqual(pathToMethodMap["/query"], "query")
        XCTAssertEqual(pathToMethodMap["/validators"], "validators")
    }
    
    func testMethodToPathMap() throws {
        XCTAssertFalse(methodToPathMap.isEmpty)
        XCTAssertEqual(methodToPathMap["block"], "/block")
        XCTAssertEqual(methodToPathMap["status"], "/status")
        XCTAssertEqual(methodToPathMap["query"], "/query")
        XCTAssertEqual(methodToPathMap["validators"], "/validators")
    }
    
    func testPathMethodMappingConsistency() throws {
        // Test that pathToMethodMap and methodToPathMap are consistent
        for (path, method) in pathToMethodMap {
            XCTAssertEqual(methodToPathMap[method], path)
        }
        
        for (method, path) in methodToPathMap {
            XCTAssertEqual(pathToMethodMap[path], method)
        }
    }
    
    // MARK: - CommonRpcMethods Tests
    
    func testCommonRpcMethods() throws {
        XCTAssertEqual(CommonRpcMethods.block, "block")
        XCTAssertEqual(CommonRpcMethods.status, "status")
        XCTAssertEqual(CommonRpcMethods.query, "query")
        XCTAssertEqual(CommonRpcMethods.validators, "validators")
        XCTAssertEqual(CommonRpcMethods.networkInfo, "network_info")
        XCTAssertEqual(CommonRpcMethods.gasPrice, "gas_price")
        XCTAssertEqual(CommonRpcMethods.health, "health")
    }
    
    func testExperimentalRpcMethods() throws {
        XCTAssertEqual(CommonRpcMethods.experimentalChanges, "EXPERIMENTAL_changes")
        XCTAssertEqual(CommonRpcMethods.experimentalCongestionLevel, "EXPERIMENTAL_congestion_level")
        XCTAssertEqual(CommonRpcMethods.experimentalGenesisConfig, "EXPERIMENTAL_genesis_config")
        XCTAssertEqual(CommonRpcMethods.experimentalSplitStorageInfo, "EXPERIMENTAL_split_storage_info")
        XCTAssertEqual(CommonRpcMethods.experimentalTxStatus, "EXPERIMENTAL_tx_status")
    }
    
    // MARK: - RpcMethodValidator Tests
    
    func testIsValidMethod() throws {
        XCTAssertTrue(RpcMethodValidator.isValid("block"))
        XCTAssertTrue(RpcMethodValidator.isValid("status"))
        XCTAssertTrue(RpcMethodValidator.isValid("query"))
        XCTAssertTrue(RpcMethodValidator.isValid("EXPERIMENTAL_changes"))
        XCTAssertTrue(RpcMethodValidator.isValid("EXPERIMENTAL_split_storage_info"))
        
        XCTAssertFalse(RpcMethodValidator.isValid("invalid_method"))
        XCTAssertFalse(RpcMethodValidator.isValid(""))
        XCTAssertFalse(RpcMethodValidator.isValid("block_invalid"))
    }
    
    func testPathForMethod() throws {
        XCTAssertEqual(RpcMethodValidator.path(for: "block"), "/block")
        XCTAssertEqual(RpcMethodValidator.path(for: "status"), "/status")
        XCTAssertEqual(RpcMethodValidator.path(for: "query"), "/query")
        XCTAssertEqual(RpcMethodValidator.path(for: "EXPERIMENTAL_changes"), "/EXPERIMENTAL_changes")
        
        XCTAssertNil(RpcMethodValidator.path(for: "invalid_method"))
        XCTAssertNil(RpcMethodValidator.path(for: ""))
    }
    
    func testMethodForPath() throws {
        XCTAssertEqual(RpcMethodValidator.method(for: "/block"), "block")
        XCTAssertEqual(RpcMethodValidator.method(for: "/status"), "status")
        XCTAssertEqual(RpcMethodValidator.method(for: "/query"), "query")
        XCTAssertEqual(RpcMethodValidator.method(for: "/EXPERIMENTAL_changes"), "EXPERIMENTAL_changes")
        
        XCTAssertNil(RpcMethodValidator.method(for: "/invalid_path"))
        XCTAssertNil(RpcMethodValidator.method(for: ""))
    }
    
    func testAllMethods() throws {
        let allMethods = RpcMethodValidator.allMethods()
        XCTAssertEqual(allMethods, rpcMethods)
        XCTAssertFalse(allMethods.isEmpty)
    }
    
    func testExperimentalMethodsValidator() throws {
        let experimentalMethods = RpcMethodValidator.experimentalMethods()
        let stableMethods = RpcMethodValidator.stableMethods()
        
        // All methods should be either experimental or stable
        let allMethods = RpcMethodValidator.allMethods()
        XCTAssertEqual(experimentalMethods.count + stableMethods.count, allMethods.count)
        
        // No overlap between experimental and stable
        let intersection = Set(experimentalMethods).intersection(Set(stableMethods))
        XCTAssertTrue(intersection.isEmpty)
    }
    
    // MARK: - Method Coverage Tests
    
    func testExpectedMethodsExist() throws {
        let expectedMethods = [
            "block", "chunk", "status", "query", "validators",
            "network_info", "gas_price", "health", "genesis_config",
            "client_config", "broadcast_tx_async", "broadcast_tx_commit",
            "send_tx", "tx", "changes", "block_effects",
            "light_client_proof", "next_light_client_block",
            "maintenance_windows"
        ]
        
        for method in expectedMethods {
            XCTAssertTrue(RpcMethodValidator.isValid(method), "Expected method '\(method)' should be valid")
        }
    }
    
    func testExpectedExperimentalMethodsExist() throws {
        let expectedExperimentalMethods = [
            "EXPERIMENTAL_changes", "EXPERIMENTAL_changes_in_block",
            "EXPERIMENTAL_congestion_level", "EXPERIMENTAL_genesis_config",
            "EXPERIMENTAL_light_client_block_proof", "EXPERIMENTAL_light_client_proof",
            "EXPERIMENTAL_maintenance_windows", "EXPERIMENTAL_protocol_config",
            "EXPERIMENTAL_receipt", "EXPERIMENTAL_split_storage_info",
            "EXPERIMENTAL_tx_status", "EXPERIMENTAL_validators_ordered"
        ]
        
        for method in expectedExperimentalMethods {
            XCTAssertTrue(RpcMethodValidator.isValid(method), "Expected experimental method '\(method)' should be valid")
        }
    }
}
