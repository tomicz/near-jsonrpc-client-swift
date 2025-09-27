import Foundation

/// Base error type for NEAR RPC client errors
public enum NearRpcError: Error, LocalizedError {
    case client(NearRpcClientError)
    case network(NearRpcNetworkError)
    case validation(NearRpcValidationError)
    
    public var errorDescription: String? {
        switch self {
        case .client(let error):
            return error.errorDescription
        case .network(let error):
            return error.errorDescription
        case .validation(let error):
            return error.errorDescription
        }
    }
}

/// JSON-RPC client error (error returned by the RPC server)
public struct NearRpcClientError: Error, LocalizedError {
    public let code: Int
    public let message: String
    public let data: AnyCodable?
    
    public init(code: Int, message: String, data: AnyCodable? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
    
    public var errorDescription: String? {
        return "RPC Error (\(code)): \(message)"
    }
    
    public var failureReason: String? {
        return message
    }
    
    public var recoverySuggestion: String? {
        switch code {
        case -32600:
            return "Check that your request parameters are valid"
        case -32601:
            return "The method you're calling doesn't exist. Check the method name"
        case -32602:
            return "Invalid parameters provided. Check your request parameters"
        case -32603:
            return "Internal JSON-RPC error. Try again later"
        case -32700:
            return "Invalid JSON was received. Check your request format"
        case -32000...(-32099):
            return "Server error. The RPC server encountered an error"
        default:
            return "Unknown RPC error. Check the error message for details"
        }
    }
}

/// Network-related error (connection issues, timeouts, etc.)
public struct NearRpcNetworkError: Error, LocalizedError {
    public let message: String
    public let originalError: Error?
    public let responseBody: String?
    
    public init(message: String, originalError: Error? = nil, responseBody: String? = nil) {
        self.message = message
        self.originalError = originalError
        self.responseBody = responseBody
    }
    
    public var errorDescription: String? {
        return "Network Error: \(message)"
    }
    
    public var failureReason: String? {
        if let originalError = originalError {
            return "\(message) (Original: \(originalError.localizedDescription))"
        }
        return message
    }
    
    public var recoverySuggestion: String? {
        return "Check your internet connection and try again. If the problem persists, the RPC endpoint might be down."
    }
}

/// Validation error (parameter validation, type checking, etc.)
public struct NearRpcValidationError: Error, LocalizedError {
    public let message: String
    public let field: String?
    
    public init(message: String, field: String? = nil) {
        self.message = message
        self.field = field
    }
    
    public var errorDescription: String? {
        if let field = field {
            return "Validation Error in \(field): \(message)"
        }
        return "Validation Error: \(message)"
    }
    
    public var failureReason: String? {
        return message
    }
    
    public var recoverySuggestion: String? {
        return "Check your input parameters and ensure they match the expected format"
    }
}

// MARK: - Common RPC Error Codes

extension NearRpcClientError {
    /// Parse error - Invalid JSON was received by the server
    public static let parseError = NearRpcClientError(code: -32700, message: "Parse error")
    
    /// Invalid Request - The JSON sent is not a valid Request object
    public static let invalidRequest = NearRpcClientError(code: -32600, message: "Invalid Request")
    
    /// Method not found - The method does not exist / is not available
    public static let methodNotFound = NearRpcClientError(code: -32601, message: "Method not found")
    
    /// Invalid params - Invalid method parameter(s)
    public static let invalidParams = NearRpcClientError(code: -32602, message: "Invalid params")
    
    /// Internal error - Internal JSON-RPC error
    public static let internalError = NearRpcClientError(code: -32603, message: "Internal error")
    
    /// Server error - Reserved for implementation-defined server-errors
    public static func serverError(code: Int, message: String) -> NearRpcClientError {
        return NearRpcClientError(code: code, message: message)
    }
}

// MARK: - Error Conversion

extension Error {
    /// Convert any error to NearRpcError
    public var asNearRpcError: NearRpcError {
        if let nearError = self as? NearRpcError {
            return nearError
        } else if let clientError = self as? NearRpcClientError {
            return .client(clientError)
        } else if let networkError = self as? NearRpcNetworkError {
            return .network(networkError)
        } else if let validationError = self as? NearRpcValidationError {
            return .validation(validationError)
        } else {
            return .network(NearRpcNetworkError(
                message: self.localizedDescription,
                originalError: self
            ))
        }
    }
}
