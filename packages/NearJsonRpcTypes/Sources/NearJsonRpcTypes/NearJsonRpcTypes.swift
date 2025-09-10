import Foundation

/// NEAR Protocol JSON-RPC Types
/// 
/// This package provides type-safe Swift types for NEAR Protocol's JSON-RPC API.
/// All types are automatically generated from NEAR's official OpenAPI specification.
public struct NearJsonRpcTypes {
    /// The version of this package
    public static let version = "0.1.0"
    
    /// Initialize the types package
    public init() {}
}

// MARK: - Re-exports
// Re-export all types and methods for easy access
@_exported import struct Foundation.URL
@_exported import struct Foundation.Data
@_exported import struct Foundation.Date
