// Typed RPC methods for NEAR JSON-RPC Client
// This provides a TypeScript-like API with full type safety
// The client package uses types internally but provides a clean API

import Foundation
import NearJsonRpcTypes

// MARK: - Typed RPC Methods

/// Requests the status of the connected RPC node
/// - Parameters:
///   - client: The NEAR RPC client
/// - Returns: The status response data as a Sendable wrapper
public func status(_ client: NearJsonRpcClient) async throws -> JsonData {
    let responseData = try await client.request(method: CommonRpcMethods.status)
    
    // Parse JSON manually to avoid AnyCodable decoding issues
    guard let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any] else {
        throw NearRpcError.invalidResponse
    }
    
    if let error = json["error"] as? [String: Any] {
        let rpcError = RpcError(
            code: error["code"] as? Int ?? -1,
            message: error["message"] as? String ?? "Unknown error",
            data: nil
        )
        throw NearRpcError.fromRpcError(rpcError)
    }
    
    guard let result = json["result"] as? [String: Any] else {
        throw NearRpcError.invalidResponse
    }
    
    return JsonData(result)
}

/// Returns block details for given height or hash
/// - Parameters:
///   - client: The NEAR RPC client
///   - finality: The finality type (e.g., "final", "optimistic")
/// - Returns: The block response data as a Sendable wrapper
public func block(_ client: NearJsonRpcClient, finality: String = "final") async throws -> JsonData {
    let params = ["finality": finality]
    let responseData = try await client.request(method: CommonRpcMethods.block, params: params)
    
    // Parse JSON manually to avoid AnyCodable decoding issues
    guard let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any] else {
        throw NearRpcError.invalidResponse
    }
    
    if let error = json["error"] as? [String: Any] {
        let rpcError = RpcError(
            code: error["code"] as? Int ?? -1,
            message: error["message"] as? String ?? "Unknown error",
            data: nil
        )
        throw NearRpcError.fromRpcError(rpcError)
    }
    
    guard let result = json["result"] as? [String: Any] else {
        throw NearRpcError.invalidResponse
    }
    
    return JsonData(result)
}

/// Returns gas price for a specific block
/// - Parameters:
///   - client: The NEAR RPC client
///   - blockId: The block ID (height or hash)
/// - Returns: The gas price response data as a Sendable wrapper
public func gasPrice(_ client: NearJsonRpcClient, blockId: Any? = nil) async throws -> JsonData {
    let params = blockId != nil ? ["block_id": blockId!] : [:]
    let responseData = try await client.request(method: CommonRpcMethods.gasPrice, params: params)
    
    // Parse JSON manually to avoid AnyCodable decoding issues
    guard let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any] else {
        throw NearRpcError.invalidResponse
    }
    
    if let error = json["error"] as? [String: Any] {
        let rpcError = RpcError(
            code: error["code"] as? Int ?? -1,
            message: error["message"] as? String ?? "Unknown error",
            data: nil
        )
        throw NearRpcError.fromRpcError(rpcError)
    }
    
    guard let result = json["result"] as? [String: Any] else {
        throw NearRpcError.invalidResponse
    }
    
    return JsonData(result)
}

/// Returns the current health status of the RPC node
/// - Parameters:
///   - client: The NEAR RPC client
/// - Returns: The health response (null if healthy)
public func health(_ client: NearJsonRpcClient) async throws -> Bool {
    let responseData = try await client.request(method: CommonRpcMethods.health)
    let jsonRpcResponse = try JSONDecoder().decode(JsonRpcResponse<[String: AnyCodable]?>.self, from: responseData)
    
    if let error = jsonRpcResponse.error {
        throw NearRpcError.fromRpcError(error)
    }
    
    // Health endpoint returns null for healthy, or error details for unhealthy
    return jsonRpcResponse.result == nil
}

/// Queries the current state of node network connections
/// - Parameters:
///   - client: The NEAR RPC client
/// - Returns: The network info response
public func networkInfo(_ client: NearJsonRpcClient) async throws -> [String: Any] {
    let responseData = try await client.request(method: CommonRpcMethods.networkInfo)
    let jsonRpcResponse = try JSONDecoder().decode(JsonRpcResponse<[String: AnyCodable]>.self, from: responseData)
    
    if let error = jsonRpcResponse.error {
        throw NearRpcError.fromRpcError(error)
    }
    
    guard let result = jsonRpcResponse.result else {
        throw NearRpcError.invalidResponse
    }
    
    // Convert AnyCodable values back to regular types
    var convertedResult: [String: Any] = [:]
    for (key, value) in result {
        convertedResult[key] = value.value
    }
    
    return convertedResult
}

/// Queries active validators on the network
/// - Parameters:
///   - client: The NEAR RPC client
/// - Returns: The validators response
public func validators(_ client: NearJsonRpcClient) async throws -> [String: Any] {
    let responseData = try await client.request(method: CommonRpcMethods.validators)
    let jsonRpcResponse = try JSONDecoder().decode(JsonRpcResponse<[String: AnyCodable]>.self, from: responseData)
    
    if let error = jsonRpcResponse.error {
        throw NearRpcError.fromRpcError(error)
    }
    
    guard let result = jsonRpcResponse.result else {
        throw NearRpcError.invalidResponse
    }
    
    // Convert AnyCodable values back to regular types
    var convertedResult: [String: Any] = [:]
    for (key, value) in result {
        convertedResult[key] = value.value
    }
    
    return convertedResult
}

// MARK: - Convenience Methods

/// View account information
/// - Parameters:
///   - client: The NEAR RPC client
///   - accountId: The account ID to query
///   - finality: The finality type (default: "final")
/// - Returns: The account view
public func viewAccount(_ client: NearJsonRpcClient, accountId: String, finality: String = "final") async throws -> AccountView {
    let params = [
        "request_type": "view_account",
        "finality": finality,
        "account_id": accountId
    ]
    
    let responseData = try await client.request(method: CommonRpcMethods.query, params: params)
    let jsonRpcResponse = try JSONDecoder().decode(JsonRpcResponse<AccountView>.self, from: responseData)
    
    if let error = jsonRpcResponse.error {
        throw NearRpcError.fromRpcError(error)
    }
    
    guard let result = jsonRpcResponse.result else {
        throw NearRpcError.invalidResponse
    }
    
    return result
}

/// Call a function in a contract
/// - Parameters:
///   - client: The NEAR RPC client
///   - contractId: The contract ID
///   - methodName: The method name to call
///   - args: The function arguments (JSON string)
///   - finality: The finality type (default: "final")
/// - Returns: The call result
public func viewFunction(
    _ client: NearJsonRpcClient,
    contractId: String,
    methodName: String,
    args: String = "{}",
    finality: String = "final"
) async throws -> [String: Any] {
    let argsBase64 = args.data(using: .utf8)?.base64EncodedString() ?? ""
    let params = [
        "request_type": "call_function",
        "finality": finality,
        "account_id": contractId,
        "method_name": methodName,
        "args_base64": argsBase64
    ]
    
    let responseData = try await client.request(method: CommonRpcMethods.query, params: params)
    let jsonRpcResponse = try JSONDecoder().decode(JsonRpcResponse<[String: AnyCodable]>.self, from: responseData)
    
    if let error = jsonRpcResponse.error {
        throw NearRpcError.fromRpcError(error)
    }
    
    guard let result = jsonRpcResponse.result else {
        throw NearRpcError.invalidResponse
    }
    
    // Convert AnyCodable values back to regular types
    var convertedResult: [String: Any] = [:]
    for (key, value) in result {
        convertedResult[key] = value.value
    }
    
    return convertedResult
}

// MARK: - Sendable Types

/// A Sendable wrapper for JSON data
public struct JsonData: @unchecked Sendable {
    public let value: [String: Any]
    
    public init(_ value: [String: Any]) {
        self.value = value
    }
}

// MARK: - Error Extensions

extension NearRpcError {
    /// RPC error from JSON-RPC response
    public static func fromRpcError(_ error: RpcError) -> NearRpcError {
        return .networkError(NSError(domain: "NearRpcError", code: error.code, userInfo: [
            NSLocalizedDescriptionKey: error.message,
            "rpcData": error.data as Any
        ]))
    }
}
