// Auto-generated method mapping from NEAR OpenAPI spec
// Generated on: 2025-01-27
// Do not edit manually - run 'swift package generate' to regenerate

import Foundation

/// Maps OpenAPI paths to actual JSON-RPC method names
public let pathToMethodMap: [String: String] = [
    "/": "EXPERIMENTAL_split_storage_info",
    "/EXPERIMENTAL_changes": "EXPERIMENTAL_changes",
    "/EXPERIMENTAL_changes_in_block": "EXPERIMENTAL_changes_in_block",
    "/EXPERIMENTAL_congestion_level": "EXPERIMENTAL_congestion_level",
    "/EXPERIMENTAL_genesis_config": "EXPERIMENTAL_genesis_config",
    "/EXPERIMENTAL_light_client_block_proof": "EXPERIMENTAL_light_client_block_proof",
    "/EXPERIMENTAL_light_client_proof": "EXPERIMENTAL_light_client_proof",
    "/EXPERIMENTAL_maintenance_windows": "EXPERIMENTAL_maintenance_windows",
    "/EXPERIMENTAL_protocol_config": "EXPERIMENTAL_protocol_config",
    "/EXPERIMENTAL_receipt": "EXPERIMENTAL_receipt",
    "/EXPERIMENTAL_split_storage_info": "EXPERIMENTAL_split_storage_info",
    "/EXPERIMENTAL_tx_status": "EXPERIMENTAL_tx_status",
    "/EXPERIMENTAL_validators_ordered": "EXPERIMENTAL_validators_ordered",
    "/block": "block",
    "/block_effects": "block_effects",
    "/broadcast_tx_async": "broadcast_tx_async",
    "/broadcast_tx_commit": "broadcast_tx_commit",
    "/changes": "changes",
    "/chunk": "chunk",
    "/client_config": "client_config",
    "/gas_price": "gas_price",
    "/genesis_config": "genesis_config",
    "/health": "health",
    "/light_client_proof": "light_client_proof",
    "/maintenance_windows": "maintenance_windows",
    "/network_info": "network_info",
    "/next_light_client_block": "next_light_client_block",
    "/query": "query",
    "/send_tx": "send_tx",
    "/status": "status",
    "/tx": "tx",
    "/validators": "validators"
]

/// Reverse mapping for convenience
public let methodToPathMap: [String: String] = {
    var map: [String: String] = [:]
    for (path, method) in pathToMethodMap {
        map[method] = path
    }
    return map
}()

/// Available RPC methods
public let rpcMethods: [String] = Array(pathToMethodMap.values).sorted()

/// RPC method type
public typealias RpcMethod = String

/// Common RPC methods
public enum CommonRpcMethods {
    public static let block = "block"
    public static let chunk = "chunk"
    public static let status = "status"
    public static let query = "query"
    public static let validators = "validators"
    public static let networkInfo = "network_info"
    public static let gasPrice = "gas_price"
    public static let health = "health"
    public static let genesisConfig = "genesis_config"
    public static let clientConfig = "client_config"
    public static let broadcastTxAsync = "broadcast_tx_async"
    public static let broadcastTxCommit = "broadcast_tx_commit"
    public static let sendTx = "send_tx"
    public static let tx = "tx"
    public static let changes = "changes"
    public static let blockEffects = "block_effects"
    public static let lightClientProof = "light_client_proof"
    public static let nextLightClientBlock = "next_light_client_block"
    public static let maintenanceWindows = "maintenance_windows"
    
    // Experimental methods
    public static let experimentalChanges = "EXPERIMENTAL_changes"
    public static let experimentalChangesInBlock = "EXPERIMENTAL_changes_in_block"
    public static let experimentalCongestionLevel = "EXPERIMENTAL_congestion_level"
    public static let experimentalGenesisConfig = "EXPERIMENTAL_genesis_config"
    public static let experimentalLightClientBlockProof = "EXPERIMENTAL_light_client_block_proof"
    public static let experimentalLightClientProof = "EXPERIMENTAL_light_client_proof"
    public static let experimentalMaintenanceWindows = "EXPERIMENTAL_maintenance_windows"
    public static let experimentalProtocolConfig = "EXPERIMENTAL_protocol_config"
    public static let experimentalReceipt = "EXPERIMENTAL_receipt"
    public static let experimentalSplitStorageInfo = "EXPERIMENTAL_split_storage_info"
    public static let experimentalTxStatus = "EXPERIMENTAL_tx_status"
    public static let experimentalValidatorsOrdered = "EXPERIMENTAL_validators_ordered"
}

/// Helper functions for method validation
public struct RpcMethodValidator {
    /// Check if a method is valid
    public static func isValid(_ method: String) -> Bool {
        return rpcMethods.contains(method)
    }
    
    /// Get the path for a given method
    public static func path(for method: String) -> String? {
        return methodToPathMap[method]
    }
    
    /// Get the method for a given path
    public static func method(for path: String) -> String? {
        return pathToMethodMap[path]
    }
    
    /// Get all available methods
    public static func allMethods() -> [String] {
        return rpcMethods
    }
    
    /// Get all experimental methods
    public static func experimentalMethods() -> [String] {
        return rpcMethods.filter { $0.hasPrefix("EXPERIMENTAL_") }
    }
    
    /// Get all stable methods
    public static func stableMethods() -> [String] {
        return rpcMethods.filter { !$0.hasPrefix("EXPERIMENTAL_") }
    }
}
