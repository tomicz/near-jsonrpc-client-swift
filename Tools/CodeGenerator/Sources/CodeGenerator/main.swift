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
        
        print("\n✅ Code generation setup completed!")
        print("📁 Check 'openapi-spec.json' for the fetched spec")
        print("🔧 Next: Integrate Apple's OpenAPI Generator")
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
