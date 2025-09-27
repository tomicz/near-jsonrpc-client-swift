import Foundation

// Get open api near spec
let url = URL(string: "https://raw.githubusercontent.com/near/nearcore/master/chain/jsonrpc/openapi/openapi.json")!
print("Getting near open api spec file location url \(url)")

// Get destination url path
let currentDir = FileManager.default.currentDirectoryPath
let destination = URL(fileURLWithPath: currentDir).appendingPathComponent("open-api-near-spec.json")

print("Open api download destination \(destination.path)")

// Start download from a url
let task = URLSession.shared.downloadTask(with: url) {tempURL, response, error in
    if let error = error{
        print("Download failed! \(error)")         
        exit(1)
    }
    
    guard let tempURL = tempURL else{
        print("No url recieved")
        exit(1)
    }

    do{
        if FileManager.default.fileExists(atPath: destination.path){
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.moveItem(at: tempURL, to: destination)
        print("File saved to destination \(destination.path)") 
        validateOpenApiSpec(at: destination)
    }
    catch{
        print("File error \(error)")
        exit(1)
    }

    exit(0)
 }

 task.resume()
 RunLoop.main.run()

func validateOpenApiSpec(at url: URL){
    do{
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: [])

        // check open api version
        guard let json = json as? [String: Any],
              let openapi = json["openapi"] as? String,
              openapi == "3.0.0" else{

            print("Invalid open api version")
            exit(1)
        }
        
        print("Open api version is \(openapi)")

        if let info = json["info"] as? [String: Any]{
            for (key, value) in info {
                print("\(key): \(value)")
            }
        }
        generateSwiftTypes(from: json)
    }
    catch{
        print("Error validating open api spec \(error)")
        exit(1)
    }
}

func generateSwiftTypes(from json: [String: Any]) {
    guard let components = json["components"] as? [String: Any],
          let schemas = components["schemas"] as? [String: Any] else {
        print("No schemas found")
        return
    }
    
    print("Found \(schemas.count) schemas, generating Swift types...")
    
    var generatedCode = generateFileHeader()
    
    // Generate types for each schema
    for (schemaName, schemaDefinition) in schemas {
        if let schema = schemaDefinition as? [String: Any] {
            let swiftType = generateSwiftType(name: schemaName, schema: schema)
            generatedCode += swiftType
        }
    }
    
    // Save to output file
    let outputPath = "../../packages/NearJsonRpcTypes/Types.swift"
    let outputURL = URL(fileURLWithPath: outputPath)
    
    // Create directory if it doesn't exist
    let outputDir = outputURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    
    do {
        try generatedCode.write(to: outputURL, atomically: true, encoding: .utf8)
        print("✅ Generated \(schemas.count) Swift types at: \(outputPath)")
    } catch {
        print("❌ Error writing file: \(error)")
    }
    
    // Generate RPC methods from OpenAPI paths
    generateSwiftMethods(from: json)
    
    // Generate client methods
    generateSwiftClientMethods(from: json)
}

func generateSwiftMethods(from json: [String: Any]) {
    guard let paths = json["paths"] as? [String: Any] else {
        print("No paths found in OpenAPI spec")
        return
    }
    
    print("Found \(paths.count) paths, extracting RPC methods...")
    
    // Extract path to method mapping from OpenAPI spec
    let pathToMethodMap = extractPathToMethodMap(from: paths)
    print("Extracted \(pathToMethodMap.count) method mappings from OpenAPI spec")
    
    // Generate Methods.swift file
    var generatedCode = generateMethodsFileHeader()
    
    // Generate RpcMethod enum
    generatedCode += generateRpcMethodEnum(from: pathToMethodMap)
    
    // Generate PATH_TO_METHOD_MAP dictionary
    generatedCode += generatePathToMethodMap(from: pathToMethodMap)
    
    // Save to output file
    let outputPath = "../../packages/NearJsonRpcTypes/Methods.swift"
    let outputURL = URL(fileURLWithPath: outputPath)
    
    do {
        try generatedCode.write(to: outputURL, atomically: true, encoding: .utf8)
        print("✅ Generated RPC methods at: \(outputPath)")
        print("📋 Generated \(pathToMethodMap.count) RPC methods")
    } catch {
        print("❌ Error writing methods file: \(error)")
    }
}

func extractPathToMethodMap(from paths: [String: Any]) -> [String: String] {
    var pathToMethodMap: [String: String] = [:]
    
    for (path, pathSpec) in paths {
        if let pathSpec = pathSpec as? [String: Any],
           let post = pathSpec["post"] as? [String: Any],
           let operationId = post["operationId"] as? String {
            pathToMethodMap[path] = operationId
        } else {
            print("⚠️  Path \(path) has no operationId, skipping...")
        }
    }
    
    return pathToMethodMap
}

func generateMethodsFileHeader() -> String {
    return """
    // Generated by NEAR Protocol Swift Type Generator
    // Do not edit manually - Generated from OpenAPI specification
    // Generated on: \(Date())
    
    import Foundation
    
    """
}

func generateRpcMethodEnum(from pathToMethodMap: [String: String]) -> String {
    var code = ""
    
    code += "/// Available RPC methods for NEAR Protocol\n"
    code += "public enum RpcMethod: String, CaseIterable {\n"
    
    // Sort methods for consistent output
    let sortedMethods = Array(pathToMethodMap.values).sorted()
    
    for method in sortedMethods {
        // Convert method name to Swift enum case format
        let enumCase = method.replacingOccurrences(of: "EXPERIMENTAL_", with: "EXPERIMENTAL_")
        code += "case \(enumCase) = \"\(method)\"\n"
    }
    
    code += "    /// All available RPC method names\n"
    code += "    public static let allMethods = RpcMethod.allCases.map { $0.rawValue }\n"
    code += "}\n\n"
    
    return code
}

func generatePathToMethodMap(from pathToMethodMap: [String: String]) -> String {
    var code = ""
    
    code += "/// Path to method mapping from OpenAPI specification\n"
    code += "public let PATH_TO_METHOD_MAP: [String: String] = [\n"
    
    // Sort paths for consistent output
    let sortedPaths = pathToMethodMap.keys.sorted()
    
    for path in sortedPaths {
        if let method = pathToMethodMap[path] {
            code += "    \"\(path)\": \"\(method)\",\n"
        }
    }
    
    code += "]\n"
    
    return code
}

func generateFileHeader() -> String {
    return """
    // Generated by NEAR Protocol Swift Type Generator
    // Do not edit manually - Generated from OpenAPI specification
    // Generated on: \(Date())
    
    import Foundation
    
    """
}

func generateSwiftType(name: String, schema: [String: Any]) -> String {
    let description = schema["description"] as? String
    
    // Check if it's a primitive type (should be a type alias, not a struct)
    if isPrimitiveType(schema: schema) {
        return generateTypeAlias(name: name, description: description, schema: schema)
    }
    
    // Check if it's a union type (oneOf or anyOf)
    if let oneOf = schema["oneOf"] as? [[String: Any]] {
        return generateEnum(name: name, description: description, oneOf: oneOf)
    }
    
    if let anyOf = schema["anyOf"] as? [[String: Any]] {
        return generateEnum(name: name, description: description, oneOf: anyOf)
    }
    
    // Check if it's an empty schema (no properties)
    if isEmptySchema(schema: schema) {
        return generateEmptyStruct(name: name, description: description)
    }
    
    return generateStruct(name: name, description: description, schema: schema)
}

func generateStruct(name: String, description: String?, schema: [String: Any]) -> String {
    var code = ""
    
    // Add documentation
    if let description = description {
        code += "/// \(description.replacingOccurrences(of: "\n", with: "\n/// "))\n"
    }
    
    code += "public struct \(name): Codable {\n"
    
    // Add properties
    if let properties = schema["properties"] as? [String: Any] {
        let required = schema["required"] as? [String] ?? []
        
        for (propName, propDef) in properties {
            if let prop = propDef as? [String: Any] {
                let propDescription = prop["description"] as? String
                let swiftType = mapOpenAPITypeToSwift(prop)
                let isOptional = !required.contains(propName)
                let optionalMark = isOptional ? "?" : ""
                
                if let propDescription = propDescription {
                    code += "    /// \(propDescription.replacingOccurrences(of: "\n", with: "\n    /// "))\n"
                }
                
                code += "    public let \(propName): \(swiftType)\(optionalMark)\n"
            }
        }
    }
    
    // Add initializer
    code += generateInitializer(name: name, schema: schema)
    
    code += "}\n\n"
    return code
}

func generateEnum(name: String, description: String?, oneOf: [[String: Any]]) -> String {
    var code = ""
    
    if let description = description {
        code += "/// \(description.replacingOccurrences(of: "\n", with: "\n/// "))\n"
    }
    
    code += "public enum \(name): Codable {\n"
    
    var caseNames = Set<String>()
    var caseIndex = 0
    
    // Generate cases for union types
    for (_, caseDef) in oneOf.enumerated() {
        if let properties = caseDef["properties"] as? [String: Any], !properties.isEmpty {
            // This is a struct-like case with properties
            let caseName = caseDef["title"] as? String ?? "case\(caseIndex)"
            let finalCaseName = generateUniqueCaseName(caseName.lowercased().replacingOccurrences(of: "_", with: ""), existingNames: &caseNames)
            
            // Generate associated values for the properties
            var associatedValues: [String] = []
            for (propName, propDef) in properties {
                let swiftType = mapOpenAPITypeToSwift(propDef as? [String: Any] ?? [:])
                associatedValues.append("\(propName): \(swiftType)")
            }
            
            if associatedValues.isEmpty {
                code += "    case \(finalCaseName)\n"
            } else {
                code += "    case \(finalCaseName)(\(associatedValues.joined(separator: ", ")))\n"
            }
        } else if let enumValues = caseDef["enum"] as? [String] {
            for enumValue in enumValues {
                let finalCaseName = generateUniqueCaseName(enumValue.lowercased(), existingNames: &caseNames)
                code += "    case \(finalCaseName)\n"
            }
        } else {
            // Handle cases without properties or enum values
            let finalCaseName = generateUniqueCaseName("case\(caseIndex)", existingNames: &caseNames)
            code += "    case \(finalCaseName)\n"
            caseIndex += 1
        }
    }
    
    // Add basic Codable implementation
    code += "}\n\n"
    return code
}

func generateUniqueCaseName(_ baseName: String, existingNames: inout Set<String>) -> String {
    var finalName = baseName
    var counter = 1
    
    while existingNames.contains(finalName) {
        finalName = "\(baseName)\(counter)"
        counter += 1
    }
    
    existingNames.insert(finalName)
    return finalName
}

func generateInitializer(name: String, schema: [String: Any]) -> String {
    guard let properties = schema["properties"] as? [String: Any],
          let required = schema["required"] as? [String] else {
        return ""
    }
    
    var code = "\n    public init("
    var parameters: [String] = []
    
    for (propName, propDef) in properties {
        let isOptional = !required.contains(propName)
        let optionalMark = isOptional ? "?" : ""
        let swiftType = mapOpenAPITypeToSwift(propDef as? [String: Any] ?? [:])
        // Use parameter name with type annotation
        parameters.append("\(propName): \(swiftType)\(optionalMark)")
    }
    
    code += parameters.joined(separator: ", ")
    code += ") {\n"
    
    for (propName, _) in properties {
        code += "        self.\(propName) = \(propName)\n"
    }
    
    code += "    }\n"
    return code
}

func mapOpenAPITypeToSwift(_ prop: [String: Any]) -> String {
    // Handle references
    if let ref = prop["$ref"] as? String {
        return extractTypeName(from: ref)
    }
    
    let type = prop["type"] as? String
    let format = prop["format"] as? String
    
    switch (type, format) {
    case ("integer", "uint64"):
        return "UInt64"
    case ("integer", "int32"):
        return "Int32"
    case ("integer", nil):
        return "Int"
    case ("string", nil):
        return "String"
    case ("boolean", nil):
        return "Bool"
    case ("array", _):
        if let items = prop["items"] as? [String: Any] {
            let elementType = mapOpenAPITypeToSwift(items)
            return "[\(elementType)]"
        }
        return "[String]" // Use String instead of Any for arrays
    case ("object", _):
        return "String" // Use String instead of Any for objects
    default:
        return "String" // Use String instead of Any for unknown types
    }
}

func extractTypeName(from ref: String) -> String {
    return ref.components(separatedBy: "/").last ?? "Unknown"
}

func isPrimitiveType(schema: [String: Any]) -> Bool {
    // Check if it's a simple type without properties
    if schema["type"] != nil {
        let hasProperties = schema["properties"] != nil
        let hasOneOf = schema["oneOf"] != nil
        let hasAnyOf = schema["anyOf"] != nil
        
        // If it's a primitive type and has no complex structure, it should be a type alias
        return !hasProperties && !hasOneOf && !hasAnyOf
    }
    return false
}

func isEmptySchema(schema: [String: Any]) -> Bool {
    // Check if schema has no properties or only empty anyOf/oneOf
    if let properties = schema["properties"] as? [String: Any], !properties.isEmpty {
        return false
    }
    
    // If it has anyOf or oneOf, it's not empty - it's a union type
    if let anyOf = schema["anyOf"] as? [[String: Any]], !anyOf.isEmpty {
        return false
    }
    
    if let oneOf = schema["oneOf"] as? [[String: Any]], !oneOf.isEmpty {
        return false
    }
    
    return schema["properties"] == nil
}

func generateTypeAlias(name: String, description: String?, schema: [String: Any]) -> String {
    var code = ""
    
    if let description = description {
        code += "/// \(description.replacingOccurrences(of: "\n", with: "\n/// "))\n"
    }
    
    let swiftType = mapOpenAPITypeToSwift(schema)
    code += "public typealias \(name) = \(swiftType)\n\n"
    
    return code
}

func generateEmptyStruct(name: String, description: String?) -> String {
    var code = ""
    
    if let description = description {
        code += "/// \(description.replacingOccurrences(of: "\n", with: "\n/// "))\n"
    }
    
    code += "public struct \(name): Codable {\n"
    code += "    public init() {}\n"
    code += "}\n\n"
    
    return code
}

func generateSwiftClientMethods(from json: [String: Any]) {
    guard let paths = json["paths"] as? [String: Any] else {
        print("No paths found in OpenAPI spec")
        return
    }
    
    print("Found \(paths.count) paths, generating client methods...")
    
    // Extract path to method mapping from OpenAPI spec
    let pathToMethodMap = extractPathToMethodMap(from: paths)
    print("Extracted \(pathToMethodMap.count) method mappings from OpenAPI spec")
    
    // Generate client methods file
    var generatedCode = generateClientMethodsFileHeader()
    
    // Generate client methods for each RPC method
    for (_, methodName) in pathToMethodMap {
        let clientMethod = generateClientMethod(methodName: methodName, paths: paths, json: json)
        generatedCode += clientMethod
    }
    
    // Close the extension
    generatedCode += "}\n"
    
    // Save to output file
    let outputPath = "../../packages/NearJsonRpcClient/Sources/NearJsonRpcClient/GeneratedMethods.swift"
    let outputURL = URL(fileURLWithPath: outputPath)
    
    // Create directory if it doesn't exist
    let outputDir = outputURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    
    do {
        try generatedCode.write(to: outputURL, atomically: true, encoding: .utf8)
        print("✅ Generated client methods at: \(outputPath)")
        print("📋 Generated \(pathToMethodMap.count) client methods")
    } catch {
        print("❌ Error writing client methods file: \(error)")
    }
}

func generateClientMethodsFileHeader() -> String {
    return """
    // Generated by NEAR Protocol Swift Client Generator
    // Do not edit manually - Generated from OpenAPI specification
    // Generated on: \(Date())
    
    import Foundation
    import NearJsonRpcTypes
    
    // MARK: - Generated Client Methods
    
    extension NearRpcClient {
    
    """
}

func generateClientMethod(methodName: String, paths: [String: Any], json: [String: Any]) -> String {
    // Convert method name to Swift method name
    let swiftMethodName = rpcMethodToCamelCase(methodName)
    
    // Find the path for this method
    let path = paths.first { (_, pathSpec) in
        if let pathSpec = pathSpec as? [String: Any],
           let post = pathSpec["post"] as? [String: Any],
           let operationId = post["operationId"] as? String {
            return operationId == methodName
        }
        return false
    }?.key
    
    guard let path = path,
          let pathSpec = paths[path] as? [String: Any],
          let post = pathSpec["post"] as? [String: Any] else {
        return ""
    }
    
    // Get method description
    let description = post["description"] as? String ?? ""
    
    // Determine if method has parameters
    // Some methods like status and network_info don't require parameters
    let hasParams = post["requestBody"] != nil && methodName != "status" && methodName != "network_info"
    
    // Generate method signature
    var methodCode = ""
    
    // Add documentation
    if !description.isEmpty {
        methodCode += "    /// \(description.replacingOccurrences(of: "\n", with: "\n    /// "))\n"
    }
    
    // Generate method signature
    if hasParams {
        methodCode += "    public func \(swiftMethodName)(params: [String: Any]) async throws -> [String: Any] {\n"
    } else {
        methodCode += "    public func \(swiftMethodName)() async throws -> [String: Any] {\n"
    }
    
    // Generate method body
    if hasParams {
        methodCode += "        let response: DictionaryResponse = try await makeRequest(method: .\(methodName), params: params)\n"
    } else {
        methodCode += "        let response: DictionaryResponse = try await makeRequest(method: .\(methodName))\n"
    }
    methodCode += "        return response.value\n"
    methodCode += "    }\n\n"
    
    return methodCode
}

func rpcMethodToCamelCase(_ method: String) -> String {
    if method.hasPrefix("EXPERIMENTAL_") {
        let suffix = String(method.dropFirst(13)) // Remove 'EXPERIMENTAL_'
        return "experimental" + suffix.components(separatedBy: "_").map { $0.capitalized }.joined()
    } else {
        let components = method.components(separatedBy: "_")
        return components.enumerated().map { index, component in
            index == 0 ? component.lowercased() : component.capitalized
        }.joined()
    }
}