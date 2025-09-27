import Foundation
import NearJsonRpcTypes

// MARK: - Convenience Methods

extension NearRpcClient {
    
    /// View account information
    /// - Parameters:
    ///   - accountId: The account ID to query
    ///   - finality: The finality type (default: "final")
    ///   - blockId: Optional specific block ID to query
    /// - Returns: Account information
    public func viewAccount(
        accountId: String,
        finality: Finality = "final",
        blockId: String? = nil
    ) async throws -> AccountView {
        // Use the generated query method
        var params: [String: Any] = [
            "request_type": "view_account",
            "account_id": accountId
        ]
        
        if let blockId = blockId {
            params["block_id"] = blockId
        } else {
            params["finality"] = finality
        }
        
        let response = try await query(params: params)
        
        // Parse the response to extract account information
        guard let accountData = response["account"] as? [String: Any] else {
            throw NearRpcValidationError(
                message: "Account not found",
                field: "accountId"
            )
        }
        
        // Convert to AccountView
        return try JSONDecoder().decode(AccountView.self, from: JSONSerialization.data(withJSONObject: accountData))
    }
    
    /// Call a view function on a contract
    /// - Parameters:
    ///   - accountId: The contract account ID
    ///   - methodName: The method name to call
    ///   - argsBase64: Base64 encoded arguments (optional)
    ///   - finality: The finality type (default: "final")
    ///   - blockId: Optional specific block ID to query
    /// - Returns: The result of the function call
    public func viewFunction(
        accountId: String,
        methodName: String,
        argsBase64: String? = nil,
        finality: Finality = "final",
        blockId: String? = nil
    ) async throws -> CallResult {
        // For now, use a simple dictionary approach until we fix the type generation
        var params: [String: Any] = [
            "request_type": "call_function",
            "account_id": accountId,
            "method_name": methodName,
            "args_base64": argsBase64 ?? ""
        ]
        
        if let blockId = blockId {
            params["block_id"] = blockId
        } else {
            params["finality"] = finality
        }
        
        let response = try await query(params: params)
        
        // Parse the response to extract call result
        guard let callResultData = response["result"] as? [String: Any] else {
            throw NearRpcValidationError(
                message: "Function call failed",
                field: "methodName"
            )
        }
        
        // Convert to CallResult - this is a temporary solution
        // TODO: Fix type generation to properly handle this
        return try JSONDecoder().decode(CallResult.self, from: JSONSerialization.data(withJSONObject: callResultData))
    }
    
    /// View access key information
    /// - Parameters:
    ///   - accountId: The account ID
    ///   - publicKey: The public key to query
    ///   - finality: The finality type (default: "final")
    ///   - blockId: Optional specific block ID to query
    /// - Returns: Access key information
    public func viewAccessKey(
        accountId: String,
        publicKey: String,
        finality: Finality = "final",
        blockId: String? = nil
    ) async throws -> AccessKeyView {
        // For now, use a simple dictionary approach until we fix the type generation
        var params: [String: Any] = [
            "request_type": "view_access_key",
            "account_id": accountId,
            "public_key": publicKey
        ]
        
        if let blockId = blockId {
            params["block_id"] = blockId
        } else {
            params["finality"] = finality
        }
        
        let response = try await query(params: params)
        
        // Parse the response to extract access key information
        guard let accessKeyData = response["access_key"] as? [String: Any] else {
            throw NearRpcValidationError(
                message: "Access key not found",
                field: "publicKey"
            )
        }
        
        // Convert to AccessKeyView - this is a temporary solution
        // TODO: Fix type generation to properly handle this
        return try JSONDecoder().decode(AccessKeyView.self, from: JSONSerialization.data(withJSONObject: accessKeyData))
    }
    
    /// Get the latest block information
    /// - Parameter finality: The finality type (default: "final")
    /// - Returns: Block information
    public func getLatestBlock(finality: Finality = "final") async throws -> [String: Any] {
        let params: [String: Any] = ["finality": finality]
        return try await block(params: params)
    }
    
    /// Get block information by ID
    /// - Parameter blockId: The block ID (hash or height)
    /// - Returns: Block information
    public func getBlock(blockId: String) async throws -> [String: Any] {
        let params: [String: Any] = ["block_id": blockId]
        return try await block(params: params)
    }
    
    /// Get network status
    /// - Returns: Network status information
    public func getStatus() async throws -> [String: Any] {
        return try await status()
    }
    
    /// Get transaction status
    /// - Parameters:
    ///   - transactionHash: The transaction hash
    ///   - senderAccountId: The sender account ID
    /// - Returns: Transaction status
    public func getTransactionStatus(
        transactionHash: String,
        senderAccountId: String
    ) async throws -> [String: Any] {
        let params: [String: Any] = [
            "transaction_hash": transactionHash,
            "sender_account_id": senderAccountId
        ]
        return try await tx(params: params)
    }
    
    /// Get gas price
    /// - Parameter blockId: Optional block ID (default: latest)
    /// - Returns: Gas price information
    public func getGasPrice(blockId: String? = nil) async throws -> [String: Any] {
        var params: [String: Any] = [:]
        if let blockId = blockId {
            params["block_id"] = blockId
        }
        return try await gasPrice(params: params)
    }
    
    /// Get network information
    /// - Returns: Network information
    public func getNetworkInfo() async throws -> [String: Any] {
        return try await networkInfo()
    }
    
    /// Get validators
    /// - Parameter blockId: Optional block ID (default: latest)
    /// - Returns: Validator information
    public func getValidators(blockId: String? = nil) async throws -> [String: Any] {
        var params: [String: Any] = [:]
        if let blockId = blockId {
            params["block_id"] = blockId
        }
        return try await validators(params: params)
    }
}

// MARK: - Utility Methods

extension NearRpcClient {
    
    /// Parse a call result to JSON
    /// - Parameter callResult: The call result from a view function
    /// - Returns: Parsed JSON object
    public func parseCallResultToJson<T: Codable>(_ callResult: CallResult) throws -> T {
        // CallResult.result is [String], so we need to join them
        let resultString = callResult.result.joined(separator: "")
        guard let data = resultString.data(using: .utf8) else {
            throw NearRpcValidationError(message: "Invalid call result data")
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// Call a view function and parse the result as JSON
    /// - Parameters:
    ///   - accountId: The contract account ID
    ///   - methodName: The method name to call
    ///   - argsBase64: Base64 encoded arguments (optional)
    ///   - finality: The finality type (default: "final")
    ///   - blockId: Optional specific block ID to query
    /// - Returns: Parsed JSON result
    public func viewFunctionAsJson<T: Codable>(
        accountId: String,
        methodName: String,
        argsBase64: String? = nil,
        finality: Finality = "final",
        blockId: String? = nil
    ) async throws -> T {
        let callResult = try await viewFunction(
            accountId: accountId,
            methodName: methodName,
            argsBase64: argsBase64,
            finality: finality,
            blockId: blockId
        )
        
        return try parseCallResultToJson(callResult)
    }
    
    /// Check if the RPC endpoint is healthy
    /// - Returns: True if the endpoint is healthy
    public func isHealthy() async -> Bool {
        do {
            _ = try await getStatus()
            return true
        } catch {
            return false
        }
    }
    
    /// Get the current block height
    /// - Parameter finality: The finality type (default: "final")
    /// - Returns: Current block height
    public func getCurrentBlockHeight(finality: Finality = "final") async throws -> UInt64 {
        let block = try await getLatestBlock(finality: finality)
        guard let header = block["header"] as? [String: Any],
              let height = header["height"] as? UInt64 else {
            throw NearRpcValidationError(message: "Invalid block response")
        }
        return height
    }
}
