import XCTest
@testable import NearJsonRpcTypes

final class IntegrationTests: XCTestCase {
    
    // MARK: - End-to-End JSON-RPC Tests
    
    func testCompleteJsonRpcRequestResponseFlow() throws {
        // Create a JSON-RPC request
        let request = JsonRpcRequest(
            id: "test-1",
            method: CommonRpcMethods.status,
            params: nil
        )
        
        // Encode the request
        let encoder = JSONEncoder()
        let requestData = try encoder.encode(request)
        let requestJson = try JSONSerialization.jsonObject(with: requestData) as? [String: Any]
        
        // Verify request structure
        XCTAssertEqual(requestJson?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestJson?["id"] as? String, "test-1")
        XCTAssertEqual(requestJson?["method"] as? String, "status")
        XCTAssertNil(requestJson?["params"])
        
        // Simulate a response using a simple string result
        let responseData = "testnet"
        
        let response = JsonRpcResponse(
            id: "test-1",
            result: responseData,
            error: nil
        )
        
        // Encode the response
        let responseDataEncoded = try encoder.encode(response)
        let responseJson = try JSONSerialization.jsonObject(with: responseDataEncoded) as? [String: Any]
        
        // Verify response structure
        XCTAssertEqual((responseJson?["jsonrpc"] as? String), "2.0")
        XCTAssertEqual((responseJson?["id"] as? String), "test-1")
        XCTAssertNotNil(responseJson?["result"])
        XCTAssertNil(responseJson?["error"])
    }
    
    func testJsonRpcErrorResponse() throws {
        let error = RpcError(
            code: -32601,
            message: "Method not found",
            data: AnyCodable("The requested method 'invalid_method' was not found")
        )
        
        let response = JsonRpcResponse<String>(
            id: "test-2",
            result: nil,
            error: error
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(response)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual((json?["jsonrpc"] as? String), "2.0")
        XCTAssertEqual((json?["id"] as? String), "test-2")
        XCTAssertNil(json?["result"])
        XCTAssertNotNil(json?["error"])
        
        let errorDict = json?["error"] as? [String: Any]
        XCTAssertEqual((errorDict?["code"] as? Int), -32601)
        XCTAssertEqual((errorDict?["message"] as? String), "Method not found")
    }
    
    // MARK: - NEAR Protocol Integration Tests
    
    func testAccountQueryRequest() throws {
        let request = JsonRpcRequest(
            id: "account-query-1",
            method: CommonRpcMethods.query,
            params: [
                "request_type": AnyCodable("view_account"),
                "finality": AnyCodable("final"),
                "account_id": AnyCodable("example.near")
            ]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["method"] as? String, "query")
        
        let params = json?["params"] as? [String: Any]
        XCTAssertEqual(params?["request_type"] as? String, "view_account")
        XCTAssertEqual(params?["finality"] as? String, "final")
        XCTAssertEqual(params?["account_id"] as? String, "example.near")
    }
    
    func testBlockQueryRequest() throws {
        let request = JsonRpcRequest(
            id: "block-query-1",
            method: CommonRpcMethods.block,
            params: [
                "finality": AnyCodable("final")
            ]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["method"] as? String, "block")
        
        let params = json?["params"] as? [String: Any]
        XCTAssertEqual(params?["finality"] as? String, "final")
    }
    
    func testValidatorsQueryRequest() throws {
        let request = JsonRpcRequest(
            id: "validators-query-1",
            method: CommonRpcMethods.validators,
            params: [
                "finality": AnyCodable("final")
            ]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["method"] as? String, "validators")
        
        let params = json?["params"] as? [String: Any]
        XCTAssertEqual(params?["finality"] as? String, "final")
    }
    
    // MARK: - Type Safety Tests
    
    func testTypeSafetyWithAccountView() throws {
        let accountView = AccountView(
            amount: "1000000000000000000000000",
            locked: "0",
            codeHash: "11111111111111111111111111111111",
            storageUsage: 182,
            storagePaidAt: 0,
            blockHeight: 12345,
            blockHash: "abc123"
        )
        
        // Test that we can use the account view in a response
        let response = JsonRpcResponse(
            id: "account-response-1",
            result: accountView,
            error: nil
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(response)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertNotNil(json?["result"])
        
        let result = json?["result"] as? [String: Any]
        XCTAssertEqual(result?["amount"] as? String, "1000000000000000000000000")
        XCTAssertEqual(result?["blockHeight"] as? Int, 12345)
    }
    
    func testTypeSafetyWithAccessKey() throws {
        let accessKey = AccessKey(
            nonce: 1,
            permission: .functionCall(FunctionCallPermission(
                allowance: "1000000000000000000000000",
                receiverId: "example.near",
                methodNames: ["transfer"]
            ))
        )
        
        // Test that we can encode/decode access keys
        let encoder = JSONEncoder()
        let data = try encoder.encode(accessKey)
        let decoder = JSONDecoder()
        let decodedAccessKey = try decoder.decode(AccessKey.self, from: data)
        
        XCTAssertEqual(decodedAccessKey.nonce, 1)
        
        switch decodedAccessKey.permission {
        case .functionCall(let permission):
            XCTAssertEqual(permission.allowance, "1000000000000000000000000")
            XCTAssertEqual(permission.receiverId, "example.near")
            XCTAssertEqual(permission.methodNames, ["transfer"])
        case .fullAccess:
            XCTFail("Expected functionCall permission")
        }
    }
    
    // MARK: - Method Validation Integration
    
    func testMethodValidationInRequest() throws {
        let validMethods = ["block", "status", "query", "validators", "EXPERIMENTAL_changes"]
        
        for method in validMethods {
            XCTAssertTrue(RpcMethodValidator.isValid(method), "Method '\(method)' should be valid")
            
            let request = JsonRpcRequest(
                id: "test-\(method)",
                method: method,
                params: nil
            )
            
            XCTAssertEqual(request.method, method)
        }
    }
    
    func testInvalidMethodHandling() throws {
        let invalidMethods = ["invalid_method", "block_invalid", "", "EXPERIMENTAL_invalid"]
        
        for method in invalidMethods {
            XCTAssertFalse(RpcMethodValidator.isValid(method), "Method '\(method)' should be invalid")
        }
    }
    
    // MARK: - Performance Tests
    
    func testEncodingPerformance() throws {
        let request = JsonRpcRequest(
            id: "perf-test",
            method: "block",
            params: [
                "finality": AnyCodable("final"),
                "block_id": AnyCodable("abc123")
            ]
        )
        
        let encoder = JSONEncoder()
        
        measure {
            for _ in 0..<1000 {
                _ = try? encoder.encode(request)
            }
        }
    }
    
    func testDecodingPerformance() throws {
        let json = """
        {
            "jsonrpc": "2.0",
            "id": "perf-test",
            "method": "block",
            "params": {
                "finality": "final",
                "block_id": "abc123"
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        measure {
            for _ in 0..<1000 {
                _ = try? decoder.decode(JsonRpcRequest.self, from: data)
            }
        }
    }
}
