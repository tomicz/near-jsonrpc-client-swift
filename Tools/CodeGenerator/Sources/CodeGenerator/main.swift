import Foundation

@main
struct CodeGenerator {
    static func main() async throws {
        print("🚀 NEAR JSON-RPC Swift Code Generator")
        print("=====================================")
        
        // Step 1: Fetch OpenAPI spec from nearcore
        print("\n📥 Step 1: Fetching NEAR OpenAPI spec...")
        let spec = try await fetchOpenApiSpec()
        
        // Step 2: Analyze the spec
        print("\n🔍 Step 2: Analyzing OpenAPI spec...")
        try analyzeSpec(spec)
        
        // Step 3: Save spec locally for inspection
        print("\n💾 Step 3: Saving spec locally...")
        try saveSpecLocally(spec)
        
        // Step 4: Extract path-to-method mapping
        print("\n🔧 Step 4: Extracting path-to-method mapping...")
        let pathToMethodMap = try await extractPathToMethodMap(from: spec)
        
        // Step 5: Generate method mapping file
        print("\n🔧 Step 5: Generating method mapping file...")
        try generateMethodMappingFile(pathToMethodMap)
        
        // Step 6: Generate Swift types using Apple's OpenAPI Generator
        print("\n🔧 Step 6: Generating Swift types...")
        try await generateSwiftTypes(from: spec)
        
        print("\n✅ Code generation completed!")
        print("📁 Check 'openapi-spec.json' for the fetched spec")
    }
    
    static func fetchOpenApiSpec() async throws -> Data {
        let url = URL(string: "https://raw.githubusercontent.com/near/nearcore/master/chain/jsonrpc/openapi/openapi.json")!
        
        print("   📡 Fetching from: \(url)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("   ✅ Status: \(httpResponse.statusCode)")
            print("   📊 Data size: \(data.count) bytes")
            
            if httpResponse.statusCode != 200 {
                throw CodeGeneratorError.failedToFetchSpec(httpResponse.statusCode)
            }
        }
        
        return data
    }
    
    static func analyzeSpec(_ data: Data) throws {
        guard let specString = String(data: data, encoding: .utf8) else {
            throw CodeGeneratorError.invalidSpecData
        }
        
        let lines = specString.components(separatedBy: .newlines)
        print("   📄 Total lines: \(lines.count)")
        
        // Count paths (RPC methods)
        let pathLines = lines.filter { $0.trimmingCharacters(in: .whitespaces).hasPrefix("/") }
        print("   🛣️ Found \(pathLines.count) API paths")
        
        // Show first few paths
        print("   📋 First few paths:")
        for (index, path) in pathLines.prefix(5).enumerated() {
            print("      \(index + 1). \(path)")
        }
        
        // Check for OpenAPI version
        if let versionLine = lines.first(where: { $0.contains("openapi:") }) {
            print("   📌 OpenAPI version: \(versionLine.trimmingCharacters(in: .whitespaces))")
        }
        
        // Count schemas
        let schemaLines = lines.filter { $0.contains("schemas:") || $0.contains("$ref:") }
        print("   📚 Found \(schemaLines.count) schema references")
    }
    
    static func saveSpecLocally(_ data: Data) throws {
        // Get the project root directory (go up from Tools/CodeGenerator/Sources/CodeGenerator/)
        let currentFile = URL(fileURLWithPath: #file)
        let projectRoot = currentFile
            .deletingLastPathComponent() // Remove main.swift
            .deletingLastPathComponent() // Remove CodeGenerator/
            .deletingLastPathComponent() // Remove Sources/
            .deletingLastPathComponent() // Remove CodeGenerator/
            .deletingLastPathComponent() // Remove Tools/
            .appendingPathComponent("near-jsonrpc-client-swift")
        
        let specPath = projectRoot.appendingPathComponent("openapi-spec.json")
        try data.write(to: specPath)
        print("   💾 Saved spec to: \(specPath.path)")
        
        // Parse and validate JSON
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) {
            print("   ✅ Valid JSON format confirmed")
            
            // Extract basic info
            if let dict = jsonObject as? [String: Any] {
                if let openapiVersion = dict["openapi"] as? String {
                    print("   📌 OpenAPI version: \(openapiVersion)")
                }
                if let info = dict["info"] as? [String: Any] {
                    if let title = info["title"] as? String {
                        print("   📋 API title: \(title)")
                    }
                    if let version = info["version"] as? String {
                        print("   🏷️ API version: \(version)")
                    }
                }
            }
        } else {
            print("   ⚠️ Warning: Invalid JSON format")
        }
    }
    
    static func snakeToCamel(_ str: String) -> String {
        let components = str.components(separatedBy: "_")
        guard let first = components.first else { return str }
        let rest = components.dropFirst().map { $0.capitalized }
        return first + rest.joined()
    }
    
    static func extractPathToMethodMap(from specData: Data) async throws -> [String: String] {
        print("   🔧 Extracting path-to-method mapping from OpenAPI spec...")
        
        guard let spec = try? JSONSerialization.jsonObject(with: specData) as? [String: Any],
              let paths = spec["paths"] as? [String: Any] else {
            throw CodeGeneratorError.specAnalysisFailed
        }
        
        var pathToMethodMap: [String: String] = [:]
        
        for (path, pathSpec) in paths {
            if let pathDict = pathSpec as? [String: Any],
               let post = pathDict["post"] as? [String: Any],
               let operationId = post["operationId"] as? String {
                pathToMethodMap[path] = operationId
            } else {
                print("   ⚠️ Warning: Path \(path) has no operationId, skipping...")
            }
        }
        
        print("   📋 Extracted \(pathToMethodMap.count) method mappings from OpenAPI spec")
        print("   📋 First few mappings:")
        for (path, method) in Array(pathToMethodMap.prefix(5)) {
            print("      - \(path) → \(method)")
        }
        if pathToMethodMap.count > 5 {
            print("      ... and \(pathToMethodMap.count - 5) more")
        }
        
        return pathToMethodMap
    }
    
    static func generateMethodMappingFile(_ pathToMethodMap: [String: String]) throws {
        print("   🔧 Generating method mapping file...")
        
        let methodMappingContent = """
        // Auto-generated method mapping from NEAR OpenAPI spec
        // Generated on: \(Date())
        // Do not edit manually - run 'swift package generate' to regenerate

        import Foundation

        /// Maps OpenAPI paths to actual JSON-RPC method names
        public let pathToMethodMap: [String: String] = [
        \(pathToMethodMap.map { "    \"\($0.key)\": \"\($0.value)\"" }.joined(separator: ",\n"))
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
        \(pathToMethodMap.values.sorted().map { method in
            let camelCase = snakeToCamel(method)
            return "    public static let \(camelCase) = \"\(method)\""
        }.joined(separator: "\n"))
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
        """
        
        // Get the project root directory (go up from Tools/CodeGenerator/Sources/CodeGenerator/)
        let currentFile = URL(fileURLWithPath: #file)
        let projectRoot = currentFile
            .deletingLastPathComponent() // Remove main.swift
            .deletingLastPathComponent() // Remove CodeGenerator/
            .deletingLastPathComponent() // Remove Sources/
            .deletingLastPathComponent() // Remove CodeGenerator/
            .deletingLastPathComponent() // Remove Tools/
            .appendingPathComponent("near-jsonrpc-client-swift")
        
        print("   📁 Project root: \(projectRoot.path)")
        
        let methodsFile = projectRoot
            .appendingPathComponent("packages")
            .appendingPathComponent("NearJsonRpcTypes")
            .appendingPathComponent("Sources")
            .appendingPathComponent("NearJsonRpcTypes")
            .appendingPathComponent("Methods.swift")
        
        print("   📁 Methods file path: \(methodsFile.path)")
        try methodMappingContent.write(to: methodsFile, atomically: true, encoding: .utf8)
        
        print("   ✅ Method mapping file generated: Methods.swift")
    }
    
    static func generateSwiftTypes(from specData: Data) async throws {
        print("   🔧 Preparing for Swift type generation...")
        
        guard let spec = try? JSONSerialization.jsonObject(with: specData) as? [String: Any],
              let components = spec["components"] as? [String: Any],
              let schemas = components["schemas"] as? [String: Any] else {
            print("   ❌ Failed to parse OpenAPI spec")
            return
        }
        
        print("   📊 Found \(schemas.count) schema definitions")
        
        // Parse all schemas
        let schemaParser = OpenAPISchemaParser()
        let swiftTypes = try schemaParser.parseSchemas(schemas)
        
        // Generate Swift code
        let swiftGenerator = SwiftTypeGenerator()
        let swiftCode = swiftGenerator.generateTypes(swiftTypes)
        
        // Write to Types.swift
        try writeTypesFile(swiftCode)
        
        print("   ✅ Generated Swift types from OpenAPI schemas")
    }
    
    static func writeTypesFile(_ content: String) throws {
        // Get the project root directory
        let currentFile = URL(fileURLWithPath: #file)
        let projectRoot = currentFile
            .deletingLastPathComponent() // Remove main.swift
            .deletingLastPathComponent() // Remove CodeGenerator/
            .deletingLastPathComponent() // Remove Sources/
            .deletingLastPathComponent() // Remove CodeGenerator/
            .deletingLastPathComponent() // Remove Tools/
            .appendingPathComponent("near-jsonrpc-client-swift")
        
        let typesFile = projectRoot
            .appendingPathComponent("packages")
            .appendingPathComponent("NearJsonRpcTypes")
            .appendingPathComponent("Sources")
            .appendingPathComponent("NearJsonRpcTypes")
            .appendingPathComponent("Types.swift")
        
        try content.write(to: typesFile, atomically: true, encoding: .utf8)
        print("   ✅ Types.swift generated successfully")
    }
}

enum CodeGeneratorError: Error {
    case failedToFetchSpec(Int)
    case invalidSpecData
    case specAnalysisFailed
    
    var localizedDescription: String {
        switch self {
        case .failedToFetchSpec(let statusCode):
            return "Failed to fetch OpenAPI spec: HTTP \(statusCode)"
        case .invalidSpecData:
            return "Invalid spec data received"
        case .specAnalysisFailed:
            return "Failed to analyze OpenAPI spec"
        }
    }
}
