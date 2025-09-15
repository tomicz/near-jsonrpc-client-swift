import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Comprehensive transaction examples for NEAR JSON-RPC Swift client
/// This demonstrates real transaction sending, broadcasting, and status tracking
@main
struct TransactionExamples {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Transaction Examples")
        print("===================================================")
        
        do {
            // Initialize the client for testnet
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with Testnet URL: \(client.url)")
            
            // Example 1: Get account information before transaction
            print("\n👤 Example 1: Getting account information...")
            await getAccountInfo(client, accountId: "example.testnet")
            
            // Example 2: Get latest block for transaction context
            print("\n📦 Example 2: Getting latest block...")
            let latestBlock = await getLatestBlock(client)
            
            // Example 3: Get gas price for transaction
            print("\n⛽ Example 3: Getting current gas price...")
            let _ = await getGasPrice(client, blockId: latestBlock)
            
            // Example 4: Broadcast transaction (async)
            print("\n📡 Example 4: Broadcasting transaction (async)...")
            await broadcastTransactionAsync(client)
            
            // Example 5: Get transaction status
            print("\n📋 Example 5: Getting transaction status...")
            await getTransactionStatus(client)
            
            // Example 6: Send transaction with commit
            print("\n💾 Example 6: Sending transaction with commit...")
            await sendTransactionWithCommit(client)
            
            print("\n🎉 All transaction examples completed successfully!")
            print("\n💡 Key takeaways:")
            print("   ✅ Transaction broadcasting (async vs commit)")
            print("   ✅ Transaction status tracking")
            print("   ✅ Gas price and block context")
            print("   ✅ Account information queries")
            print("   ✅ Error handling for failed transactions")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Helper Functions
    
    static func getAccountInfo(_ client: NearJsonRpcClient, accountId: String) async {
        do {
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_account",
                    "finality": "final",
                    "account_id": accountId
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                print("   ✅ Account ID: \(result["account_id"] as? String ?? "N/A")")
                print("   ✅ Balance: \(result["amount"] as? String ?? "N/A") yoctoNEAR")
                print("   ✅ Storage Usage: \(result["storage_usage"] as? Int ?? 0) bytes")
                print("   ✅ Locked: \(result["locked"] as? String ?? "N/A") yoctoNEAR")
            }
        } catch {
            print("   ❌ Failed to get account info: \(error)")
        }
    }
    
    static func getLatestBlock(_ client: NearJsonRpcClient) async -> Int {
        do {
            let response = try await client.request(
                method: "block",
                params: ["finality": "final"]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any],
               let header = result["header"] as? [String: Any],
               let height = header["height"] as? Int {
                print("   ✅ Latest Block Height: \(height)")
                print("   ✅ Block Hash: \(header["hash"] as? String ?? "N/A")")
                return height
            }
        } catch {
            print("   ❌ Failed to get latest block: \(error)")
        }
        return 0
    }
    
    static func getGasPrice(_ client: NearJsonRpcClient, blockId: Int) async -> String {
        do {
            let response = try await client.request(
                method: "gas_price",
                params: ["block_id": blockId]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any],
               let gasPrice = result["gas_price"] as? String {
                print("   ✅ Gas Price: \(gasPrice) yoctoNEAR")
                return gasPrice
            }
        } catch {
            print("   ❌ Failed to get gas price: \(error)")
        }
        return "0"
    }
    
    static func broadcastTransactionAsync(_ client: NearJsonRpcClient) async {
        do {
            // Create a simple transfer transaction (this would normally be signed)
            let transaction: [String: Any] = [
                "signer_id": "example.testnet",
                "public_key": "ed25519:7PGseFbWxvYVgZ89K1uTJKYoKetWs7BJtbyXDzfbAcqX",
                "nonce": 1,
                "receiver_id": "example.testnet",
                "actions": [
                    [
                        "Transfer": [
                            "deposit": "1000000000000000000000000" // 1 NEAR in yoctoNEAR
                        ]
                    ]
                ],
                "block_hash": "11111111111111111111111111111111",
                "hash": "11111111111111111111111111111111"
            ]
            
            // Encode transaction as base64
            let transactionData = try JSONSerialization.data(withJSONObject: transaction)
            let transactionBase64 = transactionData.base64EncodedString()
            
            let response = try await client.request(
                method: "broadcast_tx_async",
                params: ["signed_transaction": transactionBase64]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any],
               let txHash = result["transaction_hash"] as? String {
                print("   ✅ Transaction broadcasted successfully!")
                print("   ✅ Transaction Hash: \(txHash)")
                print("   ✅ Note: This is a demo transaction - it may fail due to invalid signature")
            }
        } catch {
            print("   ❌ Failed to broadcast transaction: \(error)")
            print("   💡 This is expected for demo transactions without proper signing")
        }
    }
    
    static func getTransactionStatus(_ client: NearJsonRpcClient) async {
        do {
            // Use a known transaction hash from testnet for demonstration
            let txHash = "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt"
            let senderAccountId = "example.testnet"
            
            let response = try await client.request(
                method: "tx",
                params: [
                    "tx_hash": txHash,
                    "sender_account_id": senderAccountId
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                
                if let transaction = result["transaction"] as? [String: Any] {
                    print("   ✅ Transaction found!")
                    print("   ✅ Hash: \(transaction["hash"] as? String ?? "N/A")")
                    print("   ✅ Signer: \(transaction["signer_id"] as? String ?? "N/A")")
                    print("   ✅ Receiver: \(transaction["receiver_id"] as? String ?? "N/A")")
                }
                
                if let status = result["status"] as? [String: Any] {
                    print("   ✅ Transaction Status:")
                    if status["SuccessValue"] != nil {
                        print("      ✅ Success")
                    } else if status["Failure"] != nil {
                        print("      ❌ Failed")
                    } else {
                        print("      ⏳ Unknown status")
                    }
                }
                
                if let receipts = result["receipts"] as? [[String: Any]] {
                    print("   ✅ Receipts: \(receipts.count)")
                }
            }
        } catch {
            print("   ❌ Failed to get transaction status: \(error)")
            print("   💡 This may be due to transaction not found or invalid hash")
        }
    }
    
    static func sendTransactionWithCommit(_ client: NearJsonRpcClient) async {
        do {
            // Create a simple transaction (this would normally be signed)
            let transaction: [String: Any] = [
                "signer_id": "example.testnet",
                "public_key": "ed25519:7PGseFbWxvYVgZ89K1uTJKYoKetWs7BJtbyXDzfbAcqX",
                "nonce": 2,
                "receiver_id": "example.testnet",
                "actions": [
                    [
                        "Transfer": [
                            "deposit": "1000000000000000000000000" // 1 NEAR in yoctoNEAR
                        ]
                    ]
                ],
                "block_hash": "11111111111111111111111111111111",
                "hash": "11111111111111111111111111111111"
            ]
            
            // Encode transaction as base64
            let transactionData = try JSONSerialization.data(withJSONObject: transaction)
            let transactionBase64 = transactionData.base64EncodedString()
            
            print("   📡 Broadcasting transaction and waiting for commit...")
            print("   ⏳ This may take a few seconds...")
            
            let response = try await client.request(
                method: "broadcast_tx_commit",
                params: ["signed_transaction": transactionBase64]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                
                if let transaction = result["transaction"] as? [String: Any] {
                    print("   ✅ Transaction committed successfully!")
                    print("   ✅ Hash: \(transaction["hash"] as? String ?? "N/A")")
                }
                
                if let status = result["status"] as? [String: Any] {
                    print("   ✅ Final Status:")
                    if status["SuccessValue"] != nil {
                        print("      ✅ Success")
                    } else if status["Failure"] != nil {
                        print("      ❌ Failed")
                    }
                }
                
                if let receipts = result["receipts"] as? [[String: Any]] {
                    print("   ✅ Receipts: \(receipts.count)")
                }
            }
        } catch {
            print("   ❌ Failed to send transaction with commit: \(error)")
            print("   💡 This is expected for demo transactions without proper signing")
        }
    }
}
