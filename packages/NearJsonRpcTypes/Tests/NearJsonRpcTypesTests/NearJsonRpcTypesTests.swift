import XCTest
@testable import NearJsonRpcTypes

final class NearJsonRpcTypesTests: XCTestCase {
    
    // MARK: - Package Tests
    
    func testPackageInitialization() throws {
        let types = NearJsonRpcTypes()
        XCTAssertNotNil(types)
    }
    
    func testVersion() throws {
        XCTAssertFalse(NearJsonRpcTypes.version.isEmpty)
        XCTAssertTrue(NearJsonRpcTypes.version.contains("."))
    }
    
    // MARK: - Type Availability Tests
    
    func testCoreTypesAreAvailable() throws {
        // Test that all core types are available and can be instantiated
        let accountId: AccountId = "test.near"
        let publicKey: PublicKey = "ed25519:ABC123"
        let balance: Balance = "1000000000000000000000000"
        let blockHeight: BlockHeight = 12345
        let gas: Gas = 30000000000000
        
        XCTAssertEqual(accountId, "test.near")
        XCTAssertEqual(publicKey, "ed25519:ABC123")
        XCTAssertEqual(balance, "1000000000000000000000000")
        XCTAssertEqual(blockHeight, 12345)
        XCTAssertEqual(gas, 30000000000000)
    }
    
    func testJsonRpcTypesAreAvailable() throws {
        // Test that JSON-RPC types are available
        let request = JsonRpcRequest(id: "test", method: "status")
        let error = RpcError(code: -1, message: "Test error")
        let codable = AnyCodable("test")
        
        XCTAssertEqual(request.id, "test")
        XCTAssertEqual(request.method, "status")
        XCTAssertEqual(error.code, -1)
        XCTAssertEqual(error.message, "Test error")
        XCTAssertEqual(codable.value as? String, "test")
    }
    
    func testMethodTypesAreAvailable() throws {
        // Test that method types are available
        XCTAssertFalse(rpcMethods.isEmpty)
        XCTAssertFalse(pathToMethodMap.isEmpty)
        XCTAssertFalse(methodToPathMap.isEmpty)
        
        // Test CommonRpcMethods enum
        XCTAssertEqual(CommonRpcMethods.block, "block")
        XCTAssertEqual(CommonRpcMethods.status, "status")
        XCTAssertEqual(CommonRpcMethods.query, "query")
    }
    
    // MARK: - Import Tests
    
    func testAllTypesCanBeImported() throws {
        // This test ensures that all types are properly exported and can be imported
        // If any type is not properly exported, this test will fail to compile
        
        // JSON-RPC types
        let _: JsonRpcRequest = JsonRpcRequest(id: "test", method: "test")
        let _: JsonRpcResponse<String> = JsonRpcResponse(id: "test", result: "test")
        let _: RpcError = RpcError(code: 0, message: "test")
        let _: AnyCodable = AnyCodable("test")
        
        // NEAR Protocol types
        let _: AccountId = "test.near"
        let _: PublicKey = "ed25519:test"
        let _: Signature = "ed25519:test"
        let _: BlockHash = "test"
        let _: TransactionHash = "test"
        let _: ChunkHash = "test"
        let _: CryptoHash = "test"
        let _: GasPrice = "100000000"
        let _: Balance = "1000000000000000000000000"
        let _: Gas = 30000000000000
        let _: BlockHeight = 12345
        let _: EpochId = "test"
        let _: ShardId = 0
        
        // Complex types
        let _: AccessKey = AccessKey(nonce: 1, permission: .fullAccess)
        let _: AccessKeyView = AccessKeyView(nonce: 1, permission: .fullAccess)
        let _: AccountView = AccountView(
            amount: "0", locked: "0", codeHash: "0", storageUsage: 0,
            storagePaidAt: 0, blockHeight: 0, blockHash: "0"
        )
        let _: BlockId = .height(0)
        let _: Finality = .final
        
        // Method types
        let _: RpcMethod = "test"
        let _: [String] = rpcMethods
        let _: [String: String] = pathToMethodMap
        let _: [String: String] = methodToPathMap
    }
}

