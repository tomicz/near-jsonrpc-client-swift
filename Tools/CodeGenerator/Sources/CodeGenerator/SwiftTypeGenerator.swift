import Foundation

/// Generates Swift code from parsed type definitions
struct SwiftTypeGenerator {
    
    func generateTypes(_ typeDefinitions: [SwiftTypeDefinition]) -> String {
        var output = generateFileHeader()
        
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
        
        var output = "\(visibility) enum \(name): Codable, Sendable {\n"
        
        // Generate cases
        for case_ in cases {
            if let associatedValue = case_.associatedValue {
                output += "    case \(case_.name)(\(associatedValue))\n"
            } else {
                output += "    case \(case_.name)\n"
            }
        }
        
        // Generate custom Codable implementation for complex enums
        if cases.contains(where: { $0.associatedValue != nil }) {
            output += generateEnumCodableImplementation(name: name, cases: cases)
        }
        
        output += "}\n"
        return output
    }
    
    private func generateEnumCodableImplementation(name: String, cases: [SwiftEnumCase]) -> String {
        var output = "\n    \(name == "ActionErrorKind" || name == "FunctionCallError" ? "public" : "internal") init(from decoder: Decoder) throws {\n"
        output += "        let container = try decoder.singleValueContainer()\n"
        output += "        if let dict = try? container.decode([String: AnyCodable].self) {\n"
        
        for case_ in cases {
            if let associatedValue = case_.associatedValue {
                output += "            if let \(case_.name.lowercased()) = dict[\"\(case_.name)\"] {\n"
                output += "                self = .\(case_.name)(try \(case_.name.lowercased()).decode(\(associatedValue).self))\n"
                output += "            } else "
            }
        }
        
        output += "{\n"
        output += "                throw DecodingError.dataCorruptedError(in: container, debugDescription: \"Invalid \(name)\")\n"
        output += "            }\n"
        output += "        } else if let stringValue = try? container.decode(String.self) {\n"
        
        // Handle string enum cases
        let stringCases = cases.filter { $0.associatedValue == nil }
        if !stringCases.isEmpty {
            output += "            switch stringValue {\n"
            for case_ in stringCases {
                output += "            case \"\(case_.name)\": self = .\(case_.name)\n"
            }
            output += "            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: \"Invalid \(name): \\(stringValue)\")\n"
            output += "            }\n"
        }
        
        output += "        } else {\n"
        output += "            throw DecodingError.dataCorruptedError(in: container, debugDescription: \"Invalid \(name)\")\n"
        output += "        }\n"
        output += "    }\n"
        
        output += "\n    func encode(to encoder: Encoder) throws {\n"
        output += "        var container = encoder.singleValueContainer()\n"
        output += "        switch self {\n"
        
        for case_ in cases {
            if case_.associatedValue != nil {
                output += "        case .\(case_.name)(let value):\n"
                output += "            try container.encode([\"\(case_.name)\": AnyCodable(value)])\n"
            } else {
                output += "        case .\(case_.name):\n"
                output += "            try container.encode(\"\(case_.name)\")\n"
            }
        }
        
        output += "        }\n"
        output += "    }\n"
        
        return output
    }
    
    private func generateTypealias(name: String, type: String, isPublic: Bool) -> String {
        let visibility = isPublic ? "public" : "internal"
        return "\(visibility) typealias \(name) = \(type)\n"
    }
}

// MARK: - Helper Extensions
