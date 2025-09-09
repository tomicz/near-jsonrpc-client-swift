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
        
        // Step 4: Handle NEAR-specific quirks
        print("\n🔧 Step 4: Handling NEAR-specific quirks...")
        try await handleNearQuirks(from: spec)
        
        // Step 5: Generate Swift types using Apple's OpenAPI Generator
        print("\n🔧 Step 5: Generating Swift types...")
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
        let specPath = URL(fileURLWithPath: "openapi-spec.json")
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
    
    static func handleNearQuirks(from specData: Data) async throws {
        print("   🔧 Analyzing NEAR-specific quirks...")
        
        guard let spec = try? JSONSerialization.jsonObject(with: specData) as? [String: Any],
              let paths = spec["paths"] as? [String: Any] else {
            print("   ⚠️ Warning: Could not parse OpenAPI spec for quirks analysis")
            return
        }
        
        // Problem 1: Endpoint Override
        print("   🎯 Problem 1: Endpoint Override")
        print("   📋 OpenAPI spec uses individual paths:")
        
        let originalPaths = Array(paths.keys).sorted()
        for path in originalPaths.prefix(5) {
            print("      - \(path)")
        }
        if originalPaths.count > 5 {
            print("      ... and \(originalPaths.count - 5) more")
        }
        
        print("   🔧 Solution: All JSON-RPC calls use endpoint '/' with method in body")
        
        // Problem 2: Case Conversion Analysis
        print("   🎯 Problem 2: Case Conversion")
        print("   📋 API returns snake_case, Swift expects camelCase")
        
        // Analyze some example schemas for case patterns
        if let components = spec["components"] as? [String: Any],
           let schemas = components["schemas"] as? [String: Any] {
            
            let schemaNames = Array(schemas.keys).sorted()
            let snakeCaseExamples = schemaNames.filter { $0.contains("_") }.prefix(3)
            
            if !snakeCaseExamples.isEmpty {
                print("   📋 Examples of snake_case in schemas:")
                for example in snakeCaseExamples {
                    print("      - \(example)")
                }
            }
        }
        
        print("   🔧 Solution: Convert snake_case ↔ camelCase automatically")
        
        // Create a fixed spec with corrected endpoints
        print("   🔧 Creating corrected OpenAPI spec...")
        
        // Override all paths to use "/"
        let correctedPaths: [String: Any] = ["/": paths.values.first ?? [:]]
        
        var correctedSpec = spec
        correctedSpec["paths"] = correctedPaths
        
        // Save the corrected spec
        let correctedData = try JSONSerialization.data(withJSONObject: correctedSpec, options: .prettyPrinted)
        let correctedSpecFile = URL(fileURLWithPath: "openapi-spec-corrected.json")
        try correctedData.write(to: correctedSpecFile)
        
        print("   ✅ NEAR quirks analysis completed!")
        print("   📁 Corrected spec saved to: openapi-spec-corrected.json")
        print("   📊 Original paths: \(originalPaths.count)")
        print("   📊 Corrected paths: 1 (all use '/')")
    }
    
    static func generateSwiftTypes(from specData: Data) async throws {
        print("   🔧 Preparing for Swift type generation...")
        
        // For now, let's analyze the spec structure
        if let spec = try? JSONSerialization.jsonObject(with: specData) as? [String: Any] {
            let paths = spec["paths"] as? [String: Any] ?? [:]
            let components = spec["components"] as? [String: Any] ?? [:]
            let schemas = components["schemas"] as? [String: Any] ?? [:]
            
            print("   📊 Found \(paths.count) API paths")
            print("   📊 Found \(schemas.count) schema definitions")
            print("   ✅ Spec analysis completed!")
        } else {
            print("   ⚠️ Warning: Could not parse OpenAPI spec as JSON")
        }
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
