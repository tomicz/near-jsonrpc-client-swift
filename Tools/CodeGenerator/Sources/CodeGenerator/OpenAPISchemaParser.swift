import Foundation

/// Parses OpenAPI schemas and converts them to Swift type definitions
struct OpenAPISchemaParser {
    
    func parseSchemas(_ schemas: [String: Any]) throws -> [SwiftTypeDefinition] {
        var swiftTypes: [SwiftTypeDefinition] = []
        var processedSchemas = Set<String>()
        
        // First pass: collect all schema names
        let schemaNames = Array(schemas.keys).sorted()
        
        // Second pass: process schemas in dependency order
        for schemaName in schemaNames {
            guard let schema = schemas[schemaName] as? [String: Any] else { continue }
            
            if !processedSchemas.contains(schemaName) {
                let swiftType = try parseSchema(name: schemaName, schema: schema, allSchemas: schemas)
                swiftTypes.append(swiftType)
                processedSchemas.insert(schemaName)
            }
        }
        
        return swiftTypes
    }
    
    private func parseSchema(name: String, schema: [String: Any], allSchemas: [String: Any]) throws -> SwiftTypeDefinition {
        let description = schema["description"] as? String
        let type = schema["type"] as? String
        
        // Handle different schema types
        if let oneOf = schema["oneOf"] as? [[String: Any]] {
            return try parseOneOfSchema(name: name, description: description, oneOf: oneOf, allSchemas: allSchemas)
        } else if let allOf = schema["allOf"] as? [[String: Any]] {
            return try parseAllOfSchema(name: name, description: description, allOf: allOf, allSchemas: allSchemas)
        } else if let properties = schema["properties"] as? [String: Any] {
            return try parseObjectSchema(name: name, description: description, properties: properties, schema: schema, allSchemas: allSchemas)
        } else if let enumValues = schema["enum"] as? [Any] {
            return try parseEnumSchema(name: name, description: description, enumValues: enumValues)
        } else if let ref = schema["$ref"] as? String {
            return try parseRefSchema(name: name, ref: ref, allSchemas: allSchemas)
        } else if type == "string" {
            return SwiftTypeDefinition(
                name: name,
                description: description,
                type: .`typealias`("String"),
                isPublic: true
            )
        } else if type == "integer" {
            return SwiftTypeDefinition(
                name: name,
                description: description,
                type: .`typealias`("Int"),
                isPublic: true
            )
        } else if type == "boolean" {
            return SwiftTypeDefinition(
                name: name,
                description: description,
                type: .`typealias`("Bool"),
                isPublic: true
            )
        } else {
            // Fallback to generic type
            return SwiftTypeDefinition(
                name: name,
                description: description,
                type: .`typealias`("AnyCodable"),
                isPublic: true
            )
        }
    }
    
    private func parseOneOfSchema(name: String, description: String?, oneOf: [[String: Any]], allSchemas: [String: Any]) throws -> SwiftTypeDefinition {
        var cases: [SwiftEnumCase] = []
        
        for variant in oneOf {
            if let enumValue = variant["enum"] as? [Any], let firstValue = enumValue.first as? String {
                // Simple enum case
                cases.append(SwiftEnumCase(name: firstValue, associatedValue: nil))
            } else if let properties = variant["properties"] as? [String: Any] {
                // Object variant - find the key
                if let (key, value) = properties.first {
                    let associatedType = try parsePropertyType(key: key, value: value, allSchemas: allSchemas)
                    cases.append(SwiftEnumCase(name: key, associatedValue: associatedType))
                }
            }
        }
        
        return SwiftTypeDefinition(
            name: name,
            description: description,
            type: .enum(cases),
            isPublic: true
        )
    }
    
    private func parseAllOfSchema(name: String, description: String?, allOf: [[String: Any]], allSchemas: [String: Any]) throws -> SwiftTypeDefinition {
        // For allOf, we'll create a struct with all properties combined
        var allProperties: [SwiftProperty] = []
        
        for schema in allOf {
            if let ref = schema["$ref"] as? String {
                let _ = try resolveRef(ref: ref, allSchemas: allSchemas)
                // For now, we'll just use the referenced type directly
                // In a more sophisticated implementation, we'd merge properties
            } else if let properties = schema["properties"] as? [String: Any] {
                for (key, value) in properties {
                    let propertyType = try parsePropertyType(key: key, value: value, allSchemas: allSchemas)
                    let required = (schema["required"] as? [String])?.contains(key) ?? false
                    allProperties.append(SwiftProperty(name: key, type: propertyType, isRequired: required))
                }
            }
        }
        
        return SwiftTypeDefinition(
            name: name,
            description: description,
            type: .struct(allProperties),
            isPublic: true
        )
    }
    
    private func parseObjectSchema(name: String, description: String?, properties: [String: Any], schema: [String: Any], allSchemas: [String: Any]) throws -> SwiftTypeDefinition {
        var swiftProperties: [SwiftProperty] = []
        let required = schema["required"] as? [String] ?? []
        
        for (key, value) in properties {
            let propertyType = try parsePropertyType(key: key, value: value, allSchemas: allSchemas)
            let isRequired = required.contains(key)
            swiftProperties.append(SwiftProperty(name: key, type: propertyType, isRequired: isRequired))
        }
        
        return SwiftTypeDefinition(
            name: name,
            description: description,
            type: .struct(swiftProperties),
            isPublic: true
        )
    }
    
    private func parseEnumSchema(name: String, description: String?, enumValues: [Any]) throws -> SwiftTypeDefinition {
        let cases = enumValues.compactMap { value in
            if let stringValue = value as? String {
                return SwiftEnumCase(name: stringValue, associatedValue: nil)
            }
            return nil
        }
        
        return SwiftTypeDefinition(
            name: name,
            description: description,
            type: .enum(cases),
            isPublic: true
        )
    }
    
    private func parseRefSchema(name: String, ref: String, allSchemas: [String: Any]) throws -> SwiftTypeDefinition {
        let refType = try resolveRef(ref: ref, allSchemas: allSchemas)
        return SwiftTypeDefinition(
            name: name,
            description: nil,
            type: .`typealias`(refType),
            isPublic: true
        )
    }
    
    private func parsePropertyType(key: String, value: Any, allSchemas: [String: Any]) throws -> String {
        if let propertySchema = value as? [String: Any] {
            if let ref = propertySchema["$ref"] as? String {
                return try resolveRef(ref: ref, allSchemas: allSchemas)
            } else if let type = propertySchema["type"] as? String {
                return swiftTypeForOpenAPIType(type, propertySchema: propertySchema)
            } else if let _ = propertySchema["oneOf"] as? [[String: Any]] {
                return "AnyCodable" // Complex union type
            }
        }
        return "AnyCodable"
    }
    
    private func resolveRef(ref: String, allSchemas: [String: Any]) throws -> String {
        // Handle $ref like "#/components/schemas/AccountId"
        if ref.hasPrefix("#/components/schemas/") {
            let schemaName = String(ref.dropFirst("#/components/schemas/".count))
            return schemaName
        }
        return "AnyCodable"
    }
    
    private func swiftTypeForOpenAPIType(_ type: String, propertySchema: [String: Any]) -> String {
        switch type {
        case "string":
            return "String"
        case "integer":
            let format = propertySchema["format"] as? String
            if format == "uint64" {
                return "UInt64"
            }
            return "Int"
        case "boolean":
            return "Bool"
        case "array":
            if let items = propertySchema["items"] as? [String: Any],
               let itemType = items["type"] as? String {
                let swiftItemType = swiftTypeForOpenAPIType(itemType, propertySchema: items)
                return "[\(swiftItemType)]"
            }
            return "[AnyCodable]"
        case "object":
            return "AnyCodable"
        default:
            return "AnyCodable"
        }
    }
}

// MARK: - Swift Type Definitions

struct SwiftTypeDefinition {
    let name: String
    let description: String?
    let type: SwiftType
    let isPublic: Bool
    
    enum SwiftType {
        case `struct`([SwiftProperty])
        case `enum`([SwiftEnumCase])
        case `typealias`(String)
    }
}

struct SwiftProperty {
    let name: String
    let type: String
    let isRequired: Bool
}

struct SwiftEnumCase {
    let name: String
    let associatedValue: String?
}
