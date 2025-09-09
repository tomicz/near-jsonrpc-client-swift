import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Advanced usage example showing how to use generated types
@main
struct AdvancedUsage {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Advanced Usage Example")
        print("=====================================================")
        
        do {
            // Initialize the client
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with Testnet URL: \(client.url)")
            
            // Example 1: Query account information
            print("\n👤 Example 1: Querying account information...")
            let accountResponse = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_account",
                    "finality": "final",
                    "account_id": "example.testnet"
                ]
            )
            
            if let accountData = try? JSONSerialization.jsonObject(with: accountResponse) as? [String: Any],
               let result = accountData["result"] as? [String: Any] {
                print("   ✅ Account ID: \(result["account_id"] as? String ?? "N/A")")
                print("   ✅ Balance: \(result["amount"] as? String ?? "N/A") yoctoNEAR")
                print("   ✅ Storage Usage: \(result["storage_usage"] as? Int ?? 0) bytes")
            }
            
            // Example 2: Get block by height
            print("\n📦 Example 2: Getting block by specific height...")
            let blockHeight = 100000000 // Example height
            let blockResponse = try await client.request(
                method: "block",
                params: ["block_id": blockHeight]
            )
            
            if let blockData = try? JSONSerialization.jsonObject(with: blockResponse) as? [String: Any],
               let result = blockData["result"] as? [String: Any],
               let header = result["header"] as? [String: Any] {
                print("   ✅ Block Height: \(header["height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(header["hash"] as? String ?? "N/A")")
                print("   ✅ Timestamp: \(header["timestamp"] as? Int ?? 0)")
            }
            
            // Example 3: Get validators
            print("\n🏛️ Example 3: Getting current validators...")
            let validatorsResponse = try await client.request(method: "validators")
            
            if let validatorsData = try? JSONSerialization.jsonObject(with: validatorsResponse) as? [String: Any],
               let result = validatorsData["result"] as? [String: Any],
               let currentValidators = result["current_validators"] as? [[String: Any]] {
                print("   ✅ Current Validators: \(currentValidators.count)")
                
                // Show first few validators
                for (index, validator) in currentValidators.prefix(3).enumerated() {
                    if let accountId = validator["account_id"] as? String {
                        print("      \(index + 1). \(accountId)")
                    }
                }
            }
            
            // Example 4: Get transaction status
            print("\n📋 Example 4: Getting transaction status...")
            // Using a known transaction hash from testnet
            let txHash = "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt"
            let txResponse = try await client.request(
                method: "tx",
                params: [
                    "tx_hash": txHash,
                    "sender_account_id": "example.testnet"
                ]
            )
            
            if let txData = try? JSONSerialization.jsonObject(with: txResponse) as? [String: Any],
               let result = txData["result"] as? [String: Any] {
                if let transaction = result["transaction"] as? [String: Any],
                   let hash = transaction["hash"] as? String {
                    print("   ✅ Transaction Hash: \(hash)")
                }
                if let status = result["status"] as? [String: Any] {
                    print("   ✅ Status: \(status["SuccessValue"] != nil ? "Success" : "Failed")")
                }
            }
            
            // Example 5: Get chunk information
            print("\n🧩 Example 5: Getting chunk information...")
            let chunkResponse = try await client.request(
                method: "chunk",
                params: ["chunk_id": "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt"]
            )
            
            if let chunkData = try? JSONSerialization.jsonObject(with: chunkResponse) as? [String: Any],
               let result = chunkData["result"] as? [String: Any] {
                if let header = result["header"] as? [String: Any] {
                    print("   ✅ Chunk Hash: \(header["chunk_hash"] as? String ?? "N/A")")
                    print("   ✅ Shard ID: \(header["shard_id"] as? Int ?? 0)")
                }
            }
            
            print("\n🎉 All advanced examples completed successfully!")
            print("\n💡 Note: These examples show how to use the basic JSON-RPC client.")
            print("   The generated types from OpenAPI will provide even better type safety!")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
}
