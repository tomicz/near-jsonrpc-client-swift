import Foundation
import NearJsonRpcTypes

/// NEAR Protocol JSON-RPC Client
/// 
/// A type-safe Swift client for NEAR Protocol's JSON-RPC API.
/// Built on top of NearJsonRpcTypes with automatic type generation.
public class NearJsonRpcClient {
    private let baseURL: URL
    
    /// Initialize the NEAR RPC client
    /// - Parameters:
    ///   - baseURL: The base URL of the NEAR RPC endpoint (e.g., "https://rpc.mainnet.near.org")
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    /// Initialize the NEAR RPC client with a string URL
    /// - Parameters:
    ///   - urlString: The URL string of the NEAR RPC endpoint
    /// - Throws: `URLError` if the URL string is invalid
    public convenience init(urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        self.init(baseURL: url)
    }
    
    /// Get the current base URL
    public var url: URL {
        return baseURL
    }
    
    /// Make a JSON-RPC request to the NEAR network
    /// - Parameters:
    ///   - method: The RPC method name
    ///   - params: The method parameters
    /// - Returns: The response data
    /// - Throws: Network or parsing errors
    public func request(method: String, params: [String: Any] = [:]) async throws -> Data {
        let requestBody: [String: Any] = [
            "jsonrpc": "2.0",
            "id": "dontcare",
            "method": method,
            "params": params
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NearRpcError.httpError((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        return data
    }
}

/// NEAR RPC Client Errors
public enum NearRpcError: Error {
    case httpError(Int)
    case invalidResponse
    case networkError(Error)
    
    public var localizedDescription: String {
        switch self {
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .invalidResponse:
            return "Invalid response format"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
