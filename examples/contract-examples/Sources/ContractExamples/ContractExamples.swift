import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Comprehensive contract interaction examples for NEAR JSON-RPC Swift client
/// This demonstrates view function calls, contract method calls, and contract state queries
@main
struct ContractExamples {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Contract Interaction Examples")
        print("============================================================")
        
        do {
            // Initialize the client for testnet
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with Testnet URL: \(client.url)")
            
            // Example 1: View contract code
            print("\n📄 Example 1: Viewing contract code...")
            await viewContractCode(client, contractId: "guest-book.testnet")
            
            // Example 2: View contract state
            print("\n🗃️ Example 2: Viewing contract state...")
            await viewContractState(client, contractId: "guest-book.testnet")
            
            // Example 3: Call view function
            print("\n👁️ Example 3: Calling view function...")
            await callViewFunction(client, contractId: "guest-book.testnet")
            
            // Example 4: View access keys
            print("\n🔑 Example 4: Viewing access keys...")
            await viewAccessKeys(client, accountId: "guest-book.testnet")
            
            // Example 5: View access key list
            print("\n📋 Example 5: Viewing access key list...")
            await viewAccessKeyList(client, accountId: "guest-book.testnet")
            
            // Example 6: Call function with parameters
            print("\n⚙️ Example 6: Calling function with parameters...")
            await callFunctionWithParams(client, contractId: "guest-book.testnet")
            
            // Example 7: Get changes in block
            print("\n🔄 Example 7: Getting changes in block...")
            await getChangesInBlock(client)
            
            print("\n🎉 All contract interaction examples completed successfully!")
            print("\n💡 Key takeaways:")
            print("   ✅ Contract code and state viewing")
            print("   ✅ View function calls (read-only)")
            print("   ✅ Access key management")
            print("   ✅ Function calls with parameters")
            print("   ✅ State change tracking")
            print("   ✅ Error handling for contract interactions")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Helper Functions
    
    static func viewContractCode(_ client: NearJsonRpcClient, contractId: String) async {
        do {
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_code",
                    "finality": "final",
                    "account_id": contractId
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Contract ID: \(result["account_id"] as? String ?? "N/A")")
                print("   ✅ Code Hash: \(result["code_hash"] as? String ?? "N/A")")
                print("   ✅ Block Height: \(result["block_height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(result["block_hash"] as? String ?? "N/A")")
                
                if let code = result["code_base64"] as? String {
                    print("   ✅ Code Size: \(code.count) characters (base64)")
                }
            }
        } catch {
            print("   ❌ Failed to view contract code: \(error)")
        }
    }
    
    static func viewContractState(_ client: NearJsonRpcClient, contractId: String) async {
        do {
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_state",
                    "finality": "final",
                    "account_id": contractId,
                    "prefix_base64": "" // Empty prefix to get all state
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Contract ID: \(result["account_id"] as? String ?? "N/A")")
                print("   ✅ Block Height: \(result["block_height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(result["block_hash"] as? String ?? "N/A")")
                
                if let values = result["values"] as? [[String: Any]] {
                    print("   ✅ State Values: \(values.count)")
                    
                    // Show first few state values
                    for (index, value) in values.prefix(3).enumerated() {
                        if let key = value["key"] as? String,
                           let valueData = value["value"] as? String {
                            print("      \(index + 1). Key: \(key)")
                            print("         Value: \(String(valueData.prefix(50)))...")
                        }
                    }
                    
                    if values.count > 3 {
                        print("      ... and \(values.count - 3) more values")
                    }
                }
            }
        } catch {
            print("   ❌ Failed to view contract state: \(error)")
        }
    }
    
    static func callViewFunction(_ client: NearJsonRpcClient, contractId: String) async {
        do {
            // Call a view function (read-only, no gas cost)
            let args = ["limit": 10] // Example parameters
            let argsData = try JSONSerialization.data(withJSONObject: args)
            let argsBase64 = argsData.base64EncodedString()
            
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "call_function",
                    "finality": "final",
                    "account_id": contractId,
                    "method_name": "get_messages",
                    "args_base64": argsBase64
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Function called successfully!")
                print("   ✅ Block Height: \(result["block_height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(result["block_hash"] as? String ?? "N/A")")
                
                if let logs = result["logs"] as? [String] {
                    print("   ✅ Logs: \(logs.count)")
                    for (index, log) in logs.prefix(3).enumerated() {
                        print("      \(index + 1). \(log)")
                    }
                }
                
                if let resultData = result["result"] as? [String] {
                    print("   ✅ Result: \(resultData.count) items")
                    if let firstResult = resultData.first {
                        print("      First result: \(String(firstResult.prefix(100)))...")
                    }
                }
            }
        } catch {
            print("   ❌ Failed to call view function: \(error)")
            print("   💡 This may be due to function not existing or invalid parameters")
        }
    }
    
    static func viewAccessKeys(_ client: NearJsonRpcClient, accountId: String) async {
        do {
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_access_key",
                    "finality": "final",
                    "account_id": accountId,
                    "public_key": "ed25519:7PGseFbWxvYVgZ89K1uTJKYoKetWs7BJtbyXDzfbAcqX"
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Access Key found!")
                print("   ✅ Account ID: \(result["account_id"] as? String ?? "N/A")")
                print("   ✅ Public Key: \(result["public_key"] as? String ?? "N/A")")
                print("   ✅ Nonce: \(result["nonce"] as? Int ?? 0)")
                print("   ✅ Block Height: \(result["block_height"] as? Int ?? 0)")
                
                if let permission = result["permission"] as? [String: Any] {
                    print("   ✅ Permission: \(permission)")
                }
            }
        } catch {
            print("   ❌ Failed to view access key: \(error)")
            print("   💡 This may be due to access key not found")
        }
    }
    
    static func viewAccessKeyList(_ client: NearJsonRpcClient, accountId: String) async {
        do {
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_access_key_list",
                    "finality": "final",
                    "account_id": accountId
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Access Key List retrieved!")
                print("   ✅ Account ID: \(result["account_id"] as? String ?? "N/A")")
                print("   ✅ Block Height: \(result["block_height"] as? Int ?? 0)")
                
                if let keys = result["keys"] as? [[String: Any]] {
                    print("   ✅ Access Keys: \(keys.count)")
                    
                    for (index, key) in keys.prefix(3).enumerated() {
                        if let publicKey = key["public_key"] as? String,
                           let nonce = key["access_key"] as? [String: Any],
                           let keyNonce = nonce["nonce"] as? Int {
                            print("      \(index + 1). Public Key: \(publicKey)")
                            print("         Nonce: \(keyNonce)")
                        }
                    }
                    
                    if keys.count > 3 {
                        print("      ... and \(keys.count - 3) more keys")
                    }
                }
            }
        } catch {
            print("   ❌ Failed to view access key list: \(error)")
        }
    }
    
    static func callFunctionWithParams(_ client: NearJsonRpcClient, contractId: String) async {
        do {
            // Call a function with specific parameters
            let args: [String: Any] = [
                "message": "Hello from Swift client!",
                "premium": false
            ]
            let argsData = try JSONSerialization.data(withJSONObject: args)
            let argsBase64 = argsData.base64EncodedString()
            
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "call_function",
                    "finality": "final",
                    "account_id": contractId,
                    "method_name": "get_messages",
                    "args_base64": argsBase64
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Function called with parameters!")
                print("   ✅ Block Height: \(result["block_height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(result["block_hash"] as? String ?? "N/A")")
                
                if let logs = result["logs"] as? [String] {
                    print("   ✅ Logs: \(logs.count)")
                    for (index, log) in logs.prefix(2).enumerated() {
                        print("      \(index + 1). \(log)")
                    }
                }
                
                if let resultData = result["result"] as? [String] {
                    print("   ✅ Result: \(resultData.count) items")
                }
            }
        } catch {
            print("   ❌ Failed to call function with parameters: \(error)")
            print("   💡 This may be due to function not existing or invalid parameters")
        }
    }
    
    static func getChangesInBlock(_ client: NearJsonRpcClient) async {
        do {
            // Get changes in a specific block
            let response = try await client.request(
                method: "EXPERIMENTAL_changes_in_block",
                params: [
                    "block_id": "final",
                    "changes_type": "all"
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Changes in block retrieved!")
                print("   ✅ Block Hash: \(result["block_hash"] as? String ?? "N/A")")
                print("   ✅ Block Height: \(result["block_height"] as? Int ?? 0)")
                
                if let changes = result["changes"] as? [[String: Any]] {
                    print("   ✅ Changes: \(changes.count)")
                    
                    for (index, change) in changes.prefix(3).enumerated() {
                        if let type = change["type"] as? String,
                           let accountId = change["account_id"] as? String {
                            print("      \(index + 1). Type: \(type)")
                            print("         Account: \(accountId)")
                        }
                    }
                    
                    if changes.count > 3 {
                        print("      ... and \(changes.count - 3) more changes")
                    }
                }
            }
        } catch {
            print("   ❌ Failed to get changes in block: \(error)")
            print("   💡 This may be due to experimental method not available")
        }
    }
}
