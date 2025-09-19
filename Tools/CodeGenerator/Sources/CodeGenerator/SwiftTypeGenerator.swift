import Foundation

/// Generates Swift code from parsed type definitions
struct SwiftTypeGenerator {
    
    func generateTypes(_ typeDefinitions: [SwiftTypeDefinition]) -> String {
        var output = generateFileHeader()
        
        // Generate AnyCodable type first
        output += generateAnyCodable()
        
        // Generate basic JSON-RPC types first
        output += generateBasicJsonRpcTypes()
        
        // Generate NEAR protocol core types
        output += generateNearCoreTypes()
        
        // Generate all parsed types
        for typeDef in typeDefinitions {
            output += generateTypeDefinition(typeDef)
            output += "\n"
        }
        
        return output
    }
    
    private func generateFileHeader() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        return """
        // Auto-generated Swift types from NEAR OpenAPI spec
        // Generated on: \(currentDate)
        // Do not edit manually - run 'swift package generate' to regenerate

        import Foundation

        // MARK: - JSON-RPC Protocol Types

        """
    }
    
    private func generateAnyCodable() -> String {
        return """
// MARK: - AnyCodable
/// A type-erased wrapper for any Codable value
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
        case let array as [Any?]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any?]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded")
            throw EncodingError.invalidValue(value, context)
        }
    }
}

"""
    }
    
    private func generateBasicJsonRpcTypes() -> String {
        return """
        /// Standard JSON-RPC 2.0 request structure
        public struct JsonRpcRequest: Codable, Sendable {
            public let jsonrpc: String
            public let id: String
            public let method: String
            public let params: [String: AnyCodable]?
            
            public init(id: String, method: String, params: [String: AnyCodable]? = nil) {
                self.jsonrpc = "2.0"
                self.id = id
                self.method = method
                self.params = params
            }
        }

        /// Standard JSON-RPC 2.0 response structure
        public struct JsonRpcResponse<T: Codable & Sendable>: Codable, Sendable {
            public let jsonrpc: String
            public let id: String
            public let result: T?
            public let error: RpcError?
            
            public init(id: String, result: T? = nil, error: RpcError? = nil) {
                self.jsonrpc = "2.0"
                self.id = id
                self.result = result
                self.error = error
            }
        }

        /// JSON-RPC error structure
        public struct RpcError: Codable, Sendable {
            public let code: Int
            public let message: String
            public let data: AnyCodable?
            public let cause: AnyCodable?
            public let name: String?
            
            public init(code: Int, message: String, data: AnyCodable? = nil, cause: AnyCodable? = nil, name: String? = nil) {
                self.code = code
                self.message = message
                self.data = data
                self.cause = cause
                self.name = name
            }
        }

        // MARK: - NEAR Protocol Core Types

        """
    }
    
    private func generateNearCoreTypes() -> String {
        return """
        /// NEAR account identifier
        public typealias AccountId = String

        /// NEAR public key (base58 encoded)
        public typealias PublicKey = String

        /// NEAR signature (base58 encoded)
        public typealias Signature = String

        /// NEAR block hash
        public typealias BlockHash = String

        /// NEAR transaction hash
        public typealias TransactionHash = String

        /// NEAR chunk hash
        public typealias ChunkHash = String

        /// NEAR crypto hash
        public typealias CryptoHash = String

        /// NEAR gas price
        public typealias GasPrice = String

        /// NEAR balance (in yoctoNEAR)
        public typealias Balance = String

        /// NEAR gas units
        public typealias Gas = UInt64

        /// NEAR block height
        public typealias BlockHeight = UInt64

        /// NEAR epoch ID
        public typealias EpochId = String

        /// NEAR shard ID
        public typealias ShardId = UInt64

        // MARK: - Generated Types from OpenAPI Schema

        """
    }
    
    private func generateTypeDefinition(_ typeDef: SwiftTypeDefinition) -> String {
        var output = ""
        
        // Add description comment if available
        if let description = typeDef.description {
            output += "/// \(description)\n"
        }
        
        // Generate the type
        switch typeDef.type {
        case .`struct`(let properties):
            output += generateStruct(name: typeDef.name, properties: properties, isPublic: typeDef.isPublic)
        case .`enum`(let cases):
            output += generateEnum(name: typeDef.name, cases: cases, isPublic: typeDef.isPublic)
        case .typealias(let type):
            output += generateTypealias(name: typeDef.name, type: type, isPublic: typeDef.isPublic)
        }
        
        return output
    }
    
    private func generateStruct(name: String, properties: [SwiftProperty], isPublic: Bool) -> String {
        let visibility = isPublic ? "public" : "internal"
        
        var output = "\(visibility) struct \(name): Codable, Sendable {\n"
        
        // Generate properties
        for property in properties {
            let optional = property.isRequired ? "" : "?"
            output += "    \(visibility) let \(property.name): \(property.type)\(optional)\n"
        }
        
        // Generate initializer
        if !properties.isEmpty {
            output += "\n    \(visibility) init("
            let initParams = properties.map { property in
                let optional = property.isRequired ? "" : " = nil"
                return "\(property.name): \(property.type)\(property.isRequired ? "" : "?")\(optional)"
            }
            output += initParams.joined(separator: ", ")
            output += ") {\n"
            
            for property in properties {
                output += "        self.\(property.name) = \(property.name)\n"
            }
            
            output += "    }\n"
        }
        
        output += "}\n"
        return output
    }
    
    private func generateEnum(name: String, cases: [SwiftEnumCase], isPublic: Bool) -> String {
        let visibility = isPublic ? "public" : "internal"
        
        var output = "\(visibility) enum \(name): String, Codable, Sendable, CaseIterable {\n"
        
        // Generate cases - simplified to string enums for now
        for case_ in cases {
            output += "    case \(case_.name) = \"\(case_.name)\"\n"
        }
        
        output += "}\n"
        return output
    }
    
    
    private func generateTypealias(name: String, type: String, isPublic: Bool) -> String {
        let visibility = isPublic ? "public" : "internal"
        return "\(visibility) typealias \(name) = \(type)\n"
    }
}

// MARK: - Helper Extensions
