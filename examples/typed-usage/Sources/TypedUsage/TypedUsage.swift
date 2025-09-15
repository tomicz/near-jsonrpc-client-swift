import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Advanced typed usage examples for NEAR JSON-RPC Swift client
/// This demonstrates the full power of type-safe operations with generated types
@main
struct TypedUsage {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Advanced Typed Usage Examples")
        print("=============================================================")
        
        do {
            // Initialize the client for testnet
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with Testnet URL: \(client.url)")
            
            // Example 1: Using typed methods for common operations
            print("\n🎯 Example 1: Using typed methods for common operations...")
            await demonstrateTypedMethods(client)
            
            // Example 2: Type-safe account operations
            print("\n👤 Example 2: Type-safe account operations...")
            await demonstrateTypedAccountOperations(client)
            
            // Example 3: Type-safe block operations
            print("\n📦 Example 3: Type-safe block operations...")
            await demonstrateTypedBlockOperations(client)
            
            // Example 4: Type-safe contract operations
            print("\n📄 Example 4: Type-safe contract operations...")
            await demonstrateTypedContractOperations(client)
            
            // Example 5: Type-safe transaction operations
            print("\n💸 Example 5: Type-safe transaction operations...")
            await demonstrateTypedTransactionOperations(client)
            
            // Example 6: Type-safe network operations
            print("\n🌐 Example 6: Type-safe network operations...")
            await demonstrateTypedNetworkOperations(client)
            
            // Example 7: Type-safe error handling
            print("\n🛡️ Example 7: Type-safe error handling...")
            await demonstrateTypedErrorHandling(client)
            
            // Example 8: Type composition and chaining
            print("\n🔗 Example 8: Type composition and chaining...")
            await demonstrateTypeComposition(client)
            
            print("\n🎉 All advanced typed usage examples completed successfully!")
            print("\n💡 Key benefits of typed operations:")
            print("   ✅ Compile-time type safety")
            print("   ✅ Auto-completion and IntelliSense")
            print("   ✅ Refactoring safety")
            print("   ✅ Documentation in code")
            print("   ✅ Reduced runtime errors")
            print("   ✅ Better developer experience")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Typed Usage Examples
    
    static func demonstrateTypedMethods(_ client: NearJsonRpcClient) async {
        print("   🎯 Demonstrating typed methods...")
        
        do {
            // Using typed status method
            let statusData = try await status(client)
            print("   ✅ Status retrieved with type safety")
            print("   ✅ Data type: \(type(of: statusData))")
            
            // Using typed block method
            let blockData = try await block(client, finality: "final")
            print("   ✅ Block retrieved with type safety")
            print("   ✅ Data type: \(type(of: blockData))")
            
            // Using typed gas price method
            let gasPriceData = try await gasPrice(client, blockId: nil)
            print("   ✅ Gas price retrieved with type safety")
            print("   ✅ Data type: \(type(of: gasPriceData))")
            
            // Using typed health method
            let isHealthy = try await health(client)
            print("   ✅ Health check completed with type safety")
            print("   ✅ Result: \(isHealthy ? "Healthy" : "Unhealthy")")
            
        } catch {
            print("   ❌ Typed methods failed: \(error)")
        }
    }
    
    static func demonstrateTypedAccountOperations(_ client: NearJsonRpcClient) async {
        print("   👤 Demonstrating typed account operations...")
        
        do {
            // Using typed viewAccount method
            let accountView = try await viewAccount(client, accountId: "example.testnet", finality: "final")
            print("   ✅ Account view retrieved with type safety")
            print("   ✅ Account ID: example.testnet")
            print("   ✅ Balance: \(accountView.amount) yoctoNEAR")
            print("   ✅ Storage Usage: \(accountView.storageUsage) bytes")
            print("   ✅ Block Height: \(accountView.blockHeight)")
            print("   ✅ Block Hash: \(accountView.blockHash)")
            
            // Type-safe access to account properties
            let balanceInNEAR = Double(accountView.amount) ?? 0.0 / 1_000_000_000_000_000_000_000_000.0
            print("   ✅ Balance: \(String(format: "%.6f", balanceInNEAR)) NEAR")
            
        } catch {
            print("   ❌ Typed account operations failed: \(error)")
        }
    }
    
    static func demonstrateTypedBlockOperations(_ client: NearJsonRpcClient) async {
        print("   📦 Demonstrating typed block operations...")
        
        do {
            // Using typed block method with different finalities
            let finalBlock = try await block(client, finality: "final")
            print("   ✅ Final block retrieved with type safety")
            print("   ✅ Block data type: \(type(of: finalBlock))")
            
            let optimisticBlock = try await block(client, finality: "optimistic")
            print("   ✅ Optimistic block retrieved with type safety")
            print("   ✅ Block data type: \(type(of: optimisticBlock))")
            
            // Type-safe access to block data
            if let finalBlockDict = finalBlock.value as? [String: Any],
               let header = finalBlockDict["header"] as? [String: Any] {
                print("   ✅ Block Height: \(header["height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(header["hash"] as? String ?? "N/A")")
                print("   ✅ Gas Price: \(header["gas_price"] as? String ?? "N/A") yoctoNEAR")
            }
            
        } catch {
            print("   ❌ Typed block operations failed: \(error)")
        }
    }
    
    static func demonstrateTypedContractOperations(_ client: NearJsonRpcClient) async {
        print("   📄 Demonstrating typed contract operations...")
        
        do {
            // Using typed viewFunction method
            let functionResult = try await viewFunction(
                client,
                contractId: "guest-book.testnet",
                methodName: "get_messages",
                args: "{\"limit\": 10}",
                finality: "final"
            )
            print("   ✅ View function called with type safety")
            print("   ✅ Result type: \(type(of: functionResult))")
            print("   ✅ Result keys: \(functionResult.keys.sorted())")
            
            // Type-safe access to function result
            if let logs = functionResult["logs"] as? [String] {
                print("   ✅ Logs: \(logs.count)")
                for (index, log) in logs.prefix(3).enumerated() {
                    print("      \(index + 1). \(log)")
                }
            }
            
            if let result = functionResult["result"] as? [String] {
                print("   ✅ Function result: \(result.count) items")
            }
            
        } catch {
            print("   ❌ Typed contract operations failed: \(error)")
        }
    }
    
    static func demonstrateTypedTransactionOperations(_ client: NearJsonRpcClient) async {
        print("   💸 Demonstrating typed transaction operations...")
        
        do {
            // Using typed methods for transaction-related operations
            let _ = try await status(client)
            print("   ✅ Status retrieved for transaction context")
            
            let _ = try await gasPrice(client, blockId: nil)
            print("   ✅ Gas price retrieved for transaction estimation")
            
            // Type-safe transaction parameter construction
            let transactionParams: [String: Any] = [
                "signer_id": "example.testnet",
                "public_key": "ed25519:7PGseFbWxvYVgZ89K1uTJKYoKetWs7BJtbyXDzfbAcqX",
                "nonce": 1,
                "receiver_id": "example.testnet",
                "actions": [
                    [
                        "Transfer": [
                            "deposit": "1000000000000000000000000" // 1 NEAR
                        ]
                    ]
                ],
                "block_hash": "11111111111111111111111111111111",
                "hash": "11111111111111111111111111111111"
            ]
            
            print("   ✅ Transaction parameters constructed with type safety")
            print("   ✅ Parameters type: \(type(of: transactionParams))")
            
            // Type-safe parameter validation
            if let signerId = transactionParams["signer_id"] as? String,
               let receiverId = transactionParams["receiver_id"] as? String {
                print("   ✅ Signer: \(signerId)")
                print("   ✅ Receiver: \(receiverId)")
            }
            
        } catch {
            print("   ❌ Typed transaction operations failed: \(error)")
        }
    }
    
    static func demonstrateTypedNetworkOperations(_ client: NearJsonRpcClient) async {
        print("   🌐 Demonstrating typed network operations...")
        
        do {
            // Using typed networkInfo method
            let networkInfo = try await networkInfo(client)
            print("   ✅ Network info retrieved with type safety")
            print("   ✅ Network info type: \(type(of: networkInfo))")
            print("   ✅ Network info keys: \(networkInfo.keys.sorted())")
            
            // Type-safe access to network information
            if let activePeers = networkInfo["active_peers"] as? [[String: Any]] {
                print("   ✅ Active Peers: \(activePeers.count)")
                
                for (index, peer) in activePeers.prefix(3).enumerated() {
                    if let accountId = peer["account_id"] as? String {
                        print("      \(index + 1). \(accountId)")
                    }
                }
            }
            
            if let numActivePeers = networkInfo["num_active_peers"] as? Int {
                print("   ✅ Number of Active Peers: \(numActivePeers)")
            }
            
            // Using typed validators method
            let validatorsInfo = try await validators(client)
            print("   ✅ Validators info retrieved with type safety")
            print("   ✅ Validators info type: \(type(of: validatorsInfo))")
            
            if let currentValidators = validatorsInfo["current_validators"] as? [[String: Any]] {
                print("   ✅ Current Validators: \(currentValidators.count)")
            }
            
        } catch {
            print("   ❌ Typed network operations failed: \(error)")
        }
    }
    
    static func demonstrateTypedErrorHandling(_ client: NearJsonRpcClient) async {
        print("   🛡️ Demonstrating typed error handling...")
        
        do {
            // Type-safe error handling with typed methods
            let _ = try await status(client)
            print("   ✅ Status retrieved with type-safe error handling")
            
        } catch let error as NearRpcError {
            // Type-safe error handling
            switch error {
            case .httpError(let code):
                print("   ❌ HTTP Error: \(code)")
            case .invalidResponse:
                print("   ❌ Invalid Response")
            case .networkError(let underlyingError):
                print("   ❌ Network Error: \(underlyingError)")
            }
        } catch {
            print("   ❌ Unexpected error: \(error)")
        }
        
        // Type-safe error handling for invalid operations
        do {
            // This will likely fail, demonstrating error handling
            let accountView = try await viewAccount(client, accountId: "non-existent-account.testnet", finality: "final")
            print("   ✅ Account view retrieved: \(accountView)")
        } catch let error as NearRpcError {
            print("   ❌ Expected error caught: \(error)")
        } catch {
            print("   ❌ Unexpected error: \(error)")
        }
    }
    
    static func demonstrateTypeComposition(_ client: NearJsonRpcClient) async {
        print("   🔗 Demonstrating type composition and chaining...")
        
        do {
            // Type-safe composition of multiple operations
            let statusData = try await status(client)
            let blockData = try await block(client, finality: "final")
            let gasPriceData = try await gasPrice(client, blockId: nil)
            
            print("   ✅ Multiple typed operations completed")
            print("   ✅ Status type: \(type(of: statusData))")
            print("   ✅ Block type: \(type(of: blockData))")
            print("   ✅ Gas price type: \(type(of: gasPriceData))")
            
            // Type-safe data composition
            let composedData: [String: Any] = [
                "status": statusData.value,
                "block": blockData.value,
                "gas_price": gasPriceData.value
            ]
            
            print("   ✅ Data composed with type safety")
            print("   ✅ Composed data keys: \(composedData.keys.sorted())")
            
            // Type-safe data extraction
            if let statusDict = composedData["status"] as? [String: Any],
               let chainId = statusDict["chain_id"] as? String {
                print("   ✅ Chain ID extracted: \(chainId)")
            }
            
            if let blockDict = composedData["block"] as? [String: Any],
               let header = blockDict["header"] as? [String: Any],
               let height = header["height"] as? Int {
                print("   ✅ Block height extracted: \(height)")
            }
            
            if let gasPriceDict = composedData["gas_price"] as? [String: Any],
               let gasPrice = gasPriceDict["gas_price"] as? String {
                print("   ✅ Gas price extracted: \(gasPrice) yoctoNEAR")
            }
            
        } catch {
            print("   ❌ Type composition failed: \(error)")
        }
    }
}
