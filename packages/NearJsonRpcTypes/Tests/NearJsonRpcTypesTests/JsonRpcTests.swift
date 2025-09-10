import XCTest
@testable import NearJsonRpcTypes

final class JsonRpcTests: XCTestCase {
    
    // MARK: - JsonRpcRequest Tests
    
    func testJsonRpcRequestCreation() throws {
        let request = JsonRpcRequest(
            id: "test-1",
            method: "block",
            params: ["finality": AnyCodable("final")]
        )
        
        XCTAssertEqual(request.id, "test-1")
        XCTAssertEqual(request.method, "block")
        XCTAssertEqual(request.jsonrpc, "2.0")
        XCTAssertNotNil(request.params)
    }
    
    func testJsonRpcRequestWithoutParams() throws {
        let request = JsonRpcRequest(
            id: "test-2",
            method: "status"
        )
        
        XCTAssertEqual(request.id, "test-2")
        XCTAssertEqual(request.method, "status")
        XCTAssertEqual(request.jsonrpc, "2.0")
        XCTAssertNil(request.params)
    }
    
    func testJsonRpcRequestEncoding() throws {
        let request = JsonRpcRequest(
            id: "test-3",
            method: "query",
            params: [
                "request_type": AnyCodable("view_account"),
                "finality": AnyCodable("final"),
                "account_id": AnyCodable("example.near")
            ]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(json?["id"] as? String, "test-3")
        XCTAssertEqual(json?["method"] as? String, "query")
        XCTAssertNotNil(json?["params"])
    }
    
    func testJsonRpcRequestDecoding() throws {
        let json = """
        {
            "jsonrpc": "2.0",
            "id": "test-4",
            "method": "block",
            "params": {
                "finality": "final"
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let request = try decoder.decode(JsonRpcRequest.self, from: data)
        
        XCTAssertEqual(request.id, "test-4")
        XCTAssertEqual(request.method, "block")
        XCTAssertEqual(request.jsonrpc, "2.0")
        XCTAssertNotNil(request.params)
    }
    
    // MARK: - JsonRpcResponse Tests
    
    func testJsonRpcResponseWithResult() throws {
        let result: [String: String] = ["block_hash": "abc123", "block_height": "12345"]
        let response = JsonRpcResponse(
            id: "test-5",
            result: result,
            error: nil
        )
        
        XCTAssertEqual(response.id, "test-5")
        XCTAssertEqual(response.jsonrpc, "2.0")
        XCTAssertNotNil(response.result)
        XCTAssertNil(response.error)
    }
    
    func testJsonRpcResponseWithError() throws {
        let error = RpcError(code: -32601, message: "Method not found")
        let response = JsonRpcResponse<String>(
            id: "test-6",
            result: nil,
            error: error
        )
        
        XCTAssertEqual(response.id, "test-6")
        XCTAssertEqual(response.jsonrpc, "2.0")
        XCTAssertNil(response.result)
        XCTAssertNotNil(response.error)
        XCTAssertEqual(response.error?.code, -32601)
        XCTAssertEqual(response.error?.message, "Method not found")
    }
    
    // MARK: - RpcError Tests
    
    func testRpcErrorCreation() throws {
        let error = RpcError(
            code: -32602,
            message: "Invalid params",
            data: AnyCodable("Additional error info")
        )
        
        XCTAssertEqual(error.code, -32602)
        XCTAssertEqual(error.message, "Invalid params")
        XCTAssertNotNil(error.data)
    }
    
    func testRpcErrorWithoutData() throws {
        let error = RpcError(code: -32600, message: "Parse error")
        
        XCTAssertEqual(error.code, -32600)
        XCTAssertEqual(error.message, "Parse error")
        XCTAssertNil(error.data)
    }
    
    // MARK: - AnyCodable Tests
    
    func testAnyCodableString() throws {
        let codable = AnyCodable("test string")
        XCTAssertEqual(codable.value as? String, "test string")
    }
    
    func testAnyCodableInt() throws {
        let codable = AnyCodable(42)
        XCTAssertEqual(codable.value as? Int, 42)
    }
    
    func testAnyCodableBool() throws {
        let codable = AnyCodable(true)
        XCTAssertEqual(codable.value as? Bool, true)
    }
    
    func testAnyCodableArray() throws {
        let codable = AnyCodable([1, 2, 3])
        XCTAssertEqual(codable.value as? [Int], [1, 2, 3])
    }
    
    func testAnyCodableDictionary() throws {
        let dict: [String: Any] = ["key": "value", "number": 123]
        let codable = AnyCodable(dict)
        
        // Test individual values since [String: Any] doesn't conform to Equatable
        let value = codable.value as? [String: Any]
        XCTAssertNotNil(value)
        XCTAssertEqual(value?["key"] as? String, "value")
        XCTAssertEqual(value?["number"] as? Int, 123)
    }
    
    func testAnyCodableEncoding() throws {
        let codable = AnyCodable(["test": "value"])
        let encoder = JSONEncoder()
        let data = try encoder.encode(codable)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["test"] as? String, "value")
    }
    
    func testAnyCodableDecoding() throws {
        let json = """
        {
            "string": "test",
            "number": 42,
            "boolean": true,
            "array": [1, 2, 3],
            "object": {"nested": "value"}
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let codable = try decoder.decode(AnyCodable.self, from: data)
        
        let value = codable.value as? [String: Any]
        XCTAssertEqual(value?["string"] as? String, "test")
        XCTAssertEqual(value?["number"] as? Int, 42)
        XCTAssertEqual(value?["boolean"] as? Bool, true)
        XCTAssertEqual(value?["array"] as? [Int], [1, 2, 3])
    }
}
