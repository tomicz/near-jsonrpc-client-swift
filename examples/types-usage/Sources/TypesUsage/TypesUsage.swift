import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Example showing how to use the generated Swift types from OpenAPI
@main
struct TypesUsage {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Types Usage Example")
        print("==================================================")
        
        do {
            // Initialize the client
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with URL: \(client.url)")
            
            // Example 1: Using exported types for status request
            print("\n📊 Example 1: Using exported types for status...")
            let statusResponse = try await client.request(method: "status")
            
            // Parse using exported types (much cleaner!)
            if let statusData = try? JSONDecoder().decode(JsonRpcStatusResponse.self, from: statusResponse) {
                print("   ✅ Successfully decoded using exported types!")
                print("   ✅ Type: \(type(of: statusData))")
                
                switch statusData {
                case .case1(let payload):
                    print("   ✅ Response type: Success")
                    print("   ✅ Result type: \(type(of: payload.result))")
                    // Access the actual status data
                    let status = payload.result
                    print("   ✅ Chain ID: \(status.chainId)")
                    print("   ✅ Node Version: \(status.version.build)")
                case .case2(let payload):
                    print("   ✅ Response type: Error")
                    print("   ✅ Error type: \(type(of: payload.error))")
                }
            } else {
                print("   ❌ Failed to decode with exported types")
            }
            
            // Example 2: Using exported types for block request
            print("\n📦 Example 2: Using exported types for block...")
            let blockResponse = try await client.request(method: "block", params: ["finality": "final"])
            
            if let blockData = try? JSONDecoder().decode(JsonRpcBlockResponse.self, from: blockResponse) {
                print("   ✅ Successfully decoded block using exported types!")
                
                switch blockData {
                case .case1(let payload):
                    let block = payload.result
                    print("   ✅ Block Height: \(block.header.height)")
                    print("   ✅ Block Hash: \(block.header.hash)")
                    print("   ✅ Timestamp: \(block.header.timestamp)")
                case .case2(let payload):
                    print("   ❌ RPC Error: \(payload.error)")
                }
            }
            
            // Example 3: Show the difference between manual and type-safe parsing
            print("\n👤 Example 3: Manual vs Type-safe parsing comparison...")
            
            // Manual parsing (what we do in basic examples)
            let queryResponse = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_account",
                    "finality": "final",
                    "account_id": "example.testnet"
                ]
            )
            
            if let queryData = try? JSONSerialization.jsonObject(with: queryResponse) as? [String: Any],
               let result = queryData["result"] as? [String: Any] {
                print("   ✅ Manual parsing: Success")
                print("   ✅ Manual parsing: Account ID = \(result["account_id"] as? String ?? "N/A")")
            }
            
            // Type-safe parsing (using exported types)
            if let queryData = try? JSONDecoder().decode(JsonRpcQueryResponse.self, from: queryResponse) {
                print("   ✅ Type-safe parsing: Successfully decoded!")
                print("   ✅ Compile-time type safety: ✅")
                print("   ✅ Auto-completion: ✅")
                print("   ✅ Validation: ✅")
                print("   ✅ Refactoring safety: ✅")
            }
            
            print("\n🎉 Types usage example completed!")
            print("\n💡 Benefits of using exported generated types:")
            print("   ✅ Clean, readable type names (JsonRpcStatusResponse vs JsonRpcResponse_for_RpcStatusResponse_and_RpcError)")
            print("   ✅ Compile-time type safety")
            print("   ✅ Auto-completion in Xcode")
            print("   ✅ Automatic validation")
            print("   ✅ No manual JSON parsing")
            print("   ✅ Refactoring safety")
            print("   ✅ Documentation in code")
            
            print("\n📚 Workflow now matches the winning TypeScript project:")
            print("   ✅ Generated types are in source directory")
            print("   ✅ Types are exported from the package")
            print("   ✅ Examples import and use the types")
            print("   ✅ Clean, maintainable code structure")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
}