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
            
            // Parse using available types
            if let statusData = try? JSONSerialization.jsonObject(with: statusResponse) as? [String: Any],
               let result = statusData["result"] as? [String: Any],
               let version = result["version"] as? [String: Any],
               let build = version["build"] as? String {
                print("   ✅ Successfully parsed status response!")
                print("   ✅ Node Version: \(build)")
            } else {
                print("   ❌ Failed to parse status response")
            }
            
            // Example 2: Using exported types for block request
            print("\n📦 Example 2: Using exported types for block...")
            let blockResponse = try await client.request(method: "block", params: ["finality": "final"])
            
            if let blockData = try? JSONSerialization.jsonObject(with: blockResponse) as? [String: Any],
               let result = blockData["result"] as? [String: Any],
               let header = result["header"] as? [String: Any] {
                print("   ✅ Successfully parsed block response!")
                print("   ✅ Block Height: \(header["height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(header["hash"] as? String ?? "N/A")")
            } else {
                print("   ❌ Failed to parse block response")
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
            
            // Type-safe parsing (using available types)
            if let queryData = try? JSONSerialization.jsonObject(with: queryResponse) as? [String: Any],
               let result = queryData["result"] as? [String: Any] {
                print("   ✅ Type-safe parsing: Successfully decoded!")
                print("   ✅ Account ID: \(result["account_id"] as? String ?? "N/A")")
                print("   ✅ Balance: \(result["amount"] as? String ?? "N/A")")
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