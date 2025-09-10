import XCTest
@testable import NearJsonRpcTypes

final class NEARTypesTests: XCTestCase {
    
    // MARK: - Account Types Tests
    
    func testAccountId() throws {
        let accountId: AccountId = "example.near"
        XCTAssertEqual(accountId, "example.near")
    }
    
    func testPublicKey() throws {
        let publicKey: PublicKey = "ed25519:ABC123"
        XCTAssertEqual(publicKey, "ed25519:ABC123")
    }
    
    func testBalance() throws {
        let balance: Balance = "1000000000000000000000000"
        XCTAssertEqual(balance, "1000000000000000000000000")
    }
    
    func testBlockHeight() throws {
        let height: BlockHeight = 12345
        XCTAssertEqual(height, 12345)
    }
    
    func testGas() throws {
        let gas: Gas = 30000000000000
        XCTAssertEqual(gas, 30000000000000)
    }
    
    // MARK: - AccessKey Tests
    
    func testAccessKeyWithFullAccess() throws {
        let accessKey = AccessKey(
            nonce: 1,
            permission: .fullAccess
        )
        
        XCTAssertEqual(accessKey.nonce, 1)
        
        switch accessKey.permission {
        case .fullAccess:
            XCTAssertTrue(true) // Success
        case .functionCall:
            XCTFail("Expected fullAccess permission")
        }
    }
    
    func testAccessKeyWithFunctionCall() throws {
        let functionCallPermission = FunctionCallPermission(
            allowance: "1000000000000000000000000",
            receiverId: "example.near",
            methodNames: ["transfer", "deposit"]
        )
        
        let accessKey = AccessKey(
            nonce: 2,
            permission: .functionCall(functionCallPermission)
        )
        
        XCTAssertEqual(accessKey.nonce, 2)
        
        switch accessKey.permission {
        case .fullAccess:
            XCTFail("Expected functionCall permission")
        case .functionCall(let permission):
            XCTAssertEqual(permission.allowance, "1000000000000000000000000")
            XCTAssertEqual(permission.receiverId, "example.near")
            XCTAssertEqual(permission.methodNames, ["transfer", "deposit"])
        }
    }
    
    func testAccessKeyEncoding() throws {
        let accessKey = AccessKey(
            nonce: 1,
            permission: .fullAccess
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(accessKey)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["nonce"] as? Int, 1)
        XCTAssertEqual(json?["permission"] as? String, "FullAccess")
    }
    
    func testAccessKeyDecoding() throws {
        let json = """
        {
            "nonce": 1,
            "permission": "FullAccess"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let accessKey = try decoder.decode(AccessKey.self, from: data)
        
        XCTAssertEqual(accessKey.nonce, 1)
        
        switch accessKey.permission {
        case .fullAccess:
            XCTAssertTrue(true) // Success
        case .functionCall:
            XCTFail("Expected fullAccess permission")
        }
    }
    
    // MARK: - AccountView Tests
    
    func testAccountViewCreation() throws {
        let accountView = AccountView(
            amount: "1000000000000000000000000",
            locked: "0",
            codeHash: "11111111111111111111111111111111",
            storageUsage: 182,
            storagePaidAt: 0,
            blockHeight: 12345,
            blockHash: "abc123"
        )
        
        XCTAssertEqual(accountView.amount, "1000000000000000000000000")
        XCTAssertEqual(accountView.locked, "0")
        XCTAssertEqual(accountView.codeHash, "11111111111111111111111111111111")
        XCTAssertEqual(accountView.storageUsage, 182)
        XCTAssertEqual(accountView.storagePaidAt, 0)
        XCTAssertEqual(accountView.blockHeight, 12345)
        XCTAssertEqual(accountView.blockHash, "abc123")
    }
    
    func testAccountViewEncoding() throws {
        let accountView = AccountView(
            amount: "1000000000000000000000000",
            locked: "0",
            codeHash: "11111111111111111111111111111111",
            storageUsage: 182,
            storagePaidAt: 0,
            blockHeight: 12345,
            blockHash: "abc123"
        )
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(accountView)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["amount"] as? String, "1000000000000000000000000")
        XCTAssertEqual(json?["locked"] as? String, "0")
        XCTAssertEqual(json?["code_hash"] as? String, "11111111111111111111111111111111")
        XCTAssertEqual(json?["storage_usage"] as? Int, 182)
        XCTAssertEqual(json?["storage_paid_at"] as? Int, 0)
        XCTAssertEqual(json?["block_height"] as? Int, 12345)
        XCTAssertEqual(json?["block_hash"] as? String, "abc123")
    }
    
    // MARK: - BlockId Tests
    
    func testBlockIdWithHash() throws {
        let blockId = BlockId.hash("abc123")
        
        switch blockId {
        case .hash(let hash):
            XCTAssertEqual(hash, "abc123")
        case .height:
            XCTFail("Expected hash block ID")
        }
    }
    
    func testBlockIdWithHeight() throws {
        let blockId = BlockId.height(12345)
        
        switch blockId {
        case .hash:
            XCTFail("Expected height block ID")
        case .height(let height):
            XCTAssertEqual(height, 12345)
        }
    }
    
    func testBlockIdEncoding() throws {
        let blockId = BlockId.hash("abc123")
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(blockId)
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        
        XCTAssertEqual(json as? String, "abc123")
    }
    
    func testBlockIdDecoding() throws {
        let json = "12345"
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let blockId = try decoder.decode(BlockId.self, from: data)
        
        switch blockId {
        case .hash:
            XCTFail("Expected height block ID")
        case .height(let height):
            XCTAssertEqual(height, 12345)
        }
    }
    
    // MARK: - Finality Tests
    
    func testFinalityValues() throws {
        XCTAssertEqual(Finality.optimistic.rawValue, "optimistic")
        XCTAssertEqual(Finality.nearFinal.rawValue, "near_final")
        XCTAssertEqual(Finality.final.rawValue, "final")
    }
    
    func testFinalityEncoding() throws {
        let finality = Finality.final
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(finality)
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        
        XCTAssertEqual(json as? String, "final")
    }
    
    func testFinalityDecoding() throws {
        let json = "\"near_final\""
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let finality = try decoder.decode(Finality.self, from: data)
        
        XCTAssertEqual(finality, .nearFinal)
    }
}
