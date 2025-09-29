import Foundation
import NearJsonRpcTypes

/// Configuration for the NEAR RPC client
public struct ClientConfig {
    public let endpoint: String
    public let headers: [String: String]
    public let timeout: TimeInterval
    public let retries: Int
    
    public init(
        endpoint: String,
        headers: [String: String] = [:],
        timeout: TimeInterval = 30.0,
        retries: Int = 3
    ) {
        self.endpoint = endpoint
        self.headers = headers
        self.timeout = timeout
        self.retries = retries
    }
}

/// JSON-RPC request structure
public struct JsonRpcRequest<T: Codable>: Codable {
    public let jsonrpc: String = "2.0"
    public let id: String
    public let method: String
    public let params: T?
    
    public init(id: String = "dontcare", method: String, params: T? = nil) {
        self.id = id
        self.method = method
        self.params = params
    }
}

/// JSON-RPC response structure
public struct JsonRpcResponse<T: Codable>: Codable {
    public let jsonrpc: String
    public let id: String
    public let result: T?
    public let error: JsonRpcError?
}

/// JSON-RPC error structure
public struct JsonRpcError: Codable {
    public let code: Int
    public let message: String
    public let data: AnyCodable?
}

/// Codable wrapper for dictionary responses
public struct DictionaryResponse: Codable {
    public let value: [String: Any]
    
    public init(_ value: [String: Any]) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode([String: AnyCodable].self).mapValues { $0.value }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let codableDict = value.mapValues { AnyCodable($0) }
        try container.encode(codableDict)
    }
}

/// Type-erased Codable wrapper for Any values
public struct AnyCodable: Codable {
    public let value: Any
    
    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.init(())
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([AnyCodable].self) {
            self.init(array.map { $0.value })
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.init(dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded")
            throw EncodingError.invalidValue(value, context)
        }
    }
}

/// NEAR RPC Client for making JSON-RPC calls to NEAR Protocol nodes
public class NearRpcClient {
    private let config: ClientConfig
    private let session: URLSession
    
    public init(config: ClientConfig) {
        self.config = config
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = config.timeout
        sessionConfig.timeoutIntervalForResource = config.timeout
        self.session = URLSession(configuration: sessionConfig)
    }
    
    public convenience init(endpoint: String) {
        self.init(config: ClientConfig(endpoint: endpoint))
    }
    
    /// Make a raw JSON-RPC request
    public func makeRequest<TParams: Codable, TResult: Codable>(
        method: RpcMethod,
        params: TParams? = nil
    ) async throws -> TResult {
        let request = JsonRpcRequest(
            method: method.rawValue,
            params: params
        )
        
        var lastError: Error?
        
        for attempt in 0...config.retries {
            do {
                let result: TResult = try await performRequest(request)
                return result
            } catch {
                lastError = error
                
                // Don't retry on client errors
                if error is NearRpcClientError {
                    throw error
                }
                
                // Don't retry if this is the last attempt
                if attempt == config.retries {
                    break
                }
                
                // Wait before retrying (exponential backoff)
                let delay = TimeInterval(pow(2.0, Double(attempt)))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw NearRpcNetworkError(
            message: "Request failed after \(config.retries + 1) attempts",
            originalError: lastError
        )
    }
    
    /// Make a raw JSON-RPC request with dictionary parameters
    public func makeRequest<TResult: Codable>(
        method: RpcMethod,
        params: [String: Any]? = nil
    ) async throws -> TResult {
        // Convert dictionary to JSON data
        let jsonData: Data?
        if let params = params {
            jsonData = try JSONSerialization.data(withJSONObject: params)
        } else {
            jsonData = nil
        }
        
        var lastError: Error?
        
        for attempt in 0...config.retries {
            do {
                let result: TResult = try await performRequestWithData(method: method, paramsData: jsonData)
                return result
            } catch {
                lastError = error
                
                // Don't retry on client errors
                if error is NearRpcClientError {
                    throw error
                }
                
                // Don't retry if this is the last attempt
                if attempt == config.retries {
                    break
                }
                
                // Wait before retrying (exponential backoff)
                let delay = TimeInterval(pow(2.0, Double(attempt)))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw NearRpcNetworkError(
            message: "Request failed after \(config.retries + 1) attempts",
            originalError: lastError
        )
    }
    
    private func performRequest<TParams: Codable, TResult: Codable>(
        _ request: JsonRpcRequest<TParams>
    ) async throws -> TResult {
        guard let url = URL(string: config.endpoint) else {
            throw NearRpcNetworkError(message: "Invalid endpoint URL: \(config.endpoint)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add custom headers
        for (key, value) in config.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Encode request with snake_case conversion
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        urlRequest.httpBody = try encoder.encode(request)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NearRpcNetworkError(message: "Invalid HTTP response")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NearRpcNetworkError(
                message: "HTTP error: \(httpResponse.statusCode)",
                responseBody: String(data: data, encoding: .utf8)
            )
        }
        
        // Decode response with camelCase conversion
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let jsonResponse: JsonRpcResponse<TResult> = try decoder.decode(JsonRpcResponse<TResult>.self, from: data)
        
        if let error = jsonResponse.error {
            throw NearRpcClientError(
                code: error.code,
                message: error.message,
                data: error.data
            )
        }
        
        guard let result = jsonResponse.result else {
            throw NearRpcClientError(
                code: -32600,
                message: "Invalid response: missing result",
                data: nil
            )
        }
        
        return result
    }
    
    private func performRequestWithData<TResult: Codable>(
        method: RpcMethod,
        paramsData: Data?
    ) async throws -> TResult {
        guard let url = URL(string: config.endpoint) else {
            throw NearRpcNetworkError(message: "Invalid endpoint URL: \(config.endpoint)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add custom headers
        for (key, value) in config.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Create JSON-RPC request manually
        var requestBody: [String: Any] = [
            "jsonrpc": "2.0",
            "id": "dontcare",
            "method": method.rawValue
        ]
        
        if let paramsData = paramsData {
            requestBody["params"] = try JSONSerialization.jsonObject(with: paramsData)
        }
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NearRpcNetworkError(message: "Invalid HTTP response")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NearRpcNetworkError(
                message: "HTTP error: \(httpResponse.statusCode)",
                responseBody: String(data: data, encoding: .utf8)
            )
        }
        
        // Parse JSON response
        let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        if let error = jsonResponse?["error"] as? [String: Any] {
            let code = error["code"] as? Int ?? -1
            let message = error["message"] as? String ?? "Unknown error"
            throw NearRpcClientError(code: code, message: message)
        }
        
        guard let result = jsonResponse?["result"] else {
            throw NearRpcClientError(
                code: -32600,
                message: "Invalid response: missing result",
                data: nil
            )
        }
        
        // Convert result to expected type
        let resultData = try JSONSerialization.data(withJSONObject: result)
        return try JSONDecoder().decode(TResult.self, from: resultData)
    }
    
    /// Create a new client with modified configuration
    public func withConfig(_ newConfig: ClientConfig) -> NearRpcClient {
        return NearRpcClient(config: newConfig)
    }
    
    /// Create a new client with modified configuration
    public func withConfig(
        endpoint: String? = nil,
        headers: [String: String]? = nil,
        timeout: TimeInterval? = nil,
        retries: Int? = nil
    ) -> NearRpcClient {
        let newConfig = ClientConfig(
            endpoint: endpoint ?? config.endpoint,
            headers: headers ?? config.headers,
            timeout: timeout ?? config.timeout,
            retries: retries ?? config.retries
        )
        return NearRpcClient(config: newConfig)
    }
}

/// Default client instance for convenience
public let defaultClient = NearRpcClient(
    config: ClientConfig(endpoint: "https://rpc.mainnet.near.org")
)
