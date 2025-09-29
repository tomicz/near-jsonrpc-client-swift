import Foundation
import NearJsonRpcTypes

// MARK: - Convenience Methods

extension NearRpcClient {
    /// Get network status
    /// - Returns: RpcStatusResponse
    public func getStatus() async throws -> RpcStatusResponse {
        return try await status()
    }

    /// Get the latest block information
    /// - Parameter finality: Finality
    /// - Returns: RpcBlockResponse
    public func getLatestBlock(finality: Finality = "final") async throws -> RpcBlockResponse {
        return try await block(params: ["finality": finality])
    }

    /// Get block information by ID
    /// - Parameter blockId: String
    /// - Returns: RpcBlockResponse
    public func getBlock(blockId: String) async throws -> RpcBlockResponse {
        return try await block(params: ["block_id": blockId])
    }

    /// Get transaction status
    /// - Parameter transactionHash: String
    /// - Parameter senderAccountId: String
    /// - Returns: RpcTransactionResponse
    public func getTransactionStatus(transactionHash: String, senderAccountId: String) async throws -> RpcTransactionResponse {
        return try await tx(params: ["transaction_hash": transactionHash, "sender_account_id": senderAccountId])
    }

    /// Get gas price
    /// - Parameter blockId: String? (optional)
    /// - Returns: RpcGasPriceResponse
    public func getGasPrice(blockId: String?) async throws -> RpcGasPriceResponse {
        return try await gasPrice(params: blockId != nil ? ["block_id": blockId!] : [:])
    }

    /// Get network information
    /// - Returns: RpcNetworkInfoResponse
    public func getNetworkInfo() async throws -> RpcNetworkInfoResponse {
        return try await networkInfo()
    }

    /// Get validators
    /// - Parameter blockId: String? (optional)
    /// - Returns: RpcValidatorResponse
    public func getValidators(blockId: String?) async throws -> RpcValidatorResponse {
        return try await validators(params: blockId != nil ? ["block_id": blockId!] : [:])
    }

}
