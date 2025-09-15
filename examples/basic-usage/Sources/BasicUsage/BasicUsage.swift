import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Enhanced basic usage example of the NEAR JSON-RPC Swift client
/// This demonstrates fundamental RPC operations with comprehensive error handling
@main
struct BasicUsage {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Enhanced Basic Usage Example")
        print("===========================================================")
        
        do {
            // Initialize the client for testnet (more stable for examples)
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with Testnet URL: \(client.url)")
            
            // Example 1: Get node status with detailed information
            print("\n📊 Example 1: Getting comprehensive node status...")
            await getNodeStatus(client)
            
            // Example 2: Get latest block with full details
            print("\n📦 Example 2: Getting latest block with details...")
            await getLatestBlockDetails(client)
            
            // Example 3: Get gas price and network economics
            print("\n⛽ Example 3: Getting gas price and network economics...")
            await getGasPriceAndEconomics(client)
            
            // Example 4: Get comprehensive network information
            print("\n🌐 Example 4: Getting comprehensive network information...")
            await getNetworkInformation(client)
            
            // Example 5: Get validators information
            print("\n🏛️ Example 5: Getting validators information...")
            await getValidatorsInformation(client)
            
            // Example 6: Get genesis configuration
            print("\n🧬 Example 6: Getting genesis configuration...")
            await getGenesisConfiguration(client)
            
            // Example 7: Health check
            print("\n💚 Example 7: Performing health check...")
            await performHealthCheck(client)
            
            print("\n🎉 All enhanced basic examples completed successfully!")
            print("\n💡 This example demonstrates:")
            print("   ✅ Comprehensive RPC method usage")
            print("   ✅ Detailed response parsing")
            print("   ✅ Error handling and validation")
            print("   ✅ Network information gathering")
            print("   ✅ Foundation for advanced operations")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Enhanced Helper Functions
    
    static func getNodeStatus(_ client: NearJsonRpcClient) async {
        do {
            let response = try await client.request(method: "status")
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                
                // Version information
                if let version = result["version"] as? [String: Any] {
                    print("   ✅ NEAR Node Version: \(version["build"] as? String ?? "N/A")")
                    print("   ✅ Version: \(version["version"] as? String ?? "N/A")")
                }
                
                // Chain information
                if let chainId = result["chain_id"] as? String {
                    print("   ✅ Chain ID: \(chainId)")
                }
                
                // Sync information
                if let syncInfo = result["sync_info"] as? [String: Any] {
                    print("   ✅ Latest Block Height: \(syncInfo["latest_block_height"] as? Int ?? 0)")
                    print("   ✅ Latest Block Hash: \(syncInfo["latest_block_hash"] as? String ?? "N/A")")
                    print("   ✅ Syncing: \(syncInfo["syncing"] as? Bool ?? false)")
                }
                
                // Validator information
                if let validatorAccountId = result["validator_account_id"] as? String {
                    print("   ✅ Validator Account: \(validatorAccountId)")
                }
            }
        } catch {
            print("   ❌ Failed to get node status: \(error)")
        }
    }
    
    static func getLatestBlockDetails(_ client: NearJsonRpcClient) async {
        do {
            let response = try await client.request(method: "block", params: ["finality": "final"])
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any],
               let header = result["header"] as? [String: Any] {
                
                print("   ✅ Block Height: \(header["height"] as? Int ?? 0)")
                print("   ✅ Block Hash: \(header["hash"] as? String ?? "N/A")")
                print("   ✅ Previous Hash: \(header["prev_hash"] as? String ?? "N/A")")
                print("   ✅ Timestamp: \(header["timestamp"] as? Int ?? 0)")
                print("   ✅ Gas Price: \(header["gas_price"] as? String ?? "N/A") yoctoNEAR")
                print("   ✅ Total Supply: \(header["total_supply"] as? String ?? "N/A") yoctoNEAR")
                
                // Chunk information
                if let chunks = result["chunks"] as? [[String: Any]] {
                    print("   ✅ Chunks: \(chunks.count)")
                }
                
                // Transactions
                if let transactions = result["transactions"] as? [[String: Any]] {
                    print("   ✅ Transactions: \(transactions.count)")
                }
            }
        } catch {
            print("   ❌ Failed to get latest block: \(error)")
        }
    }
    
    static func getGasPriceAndEconomics(_ client: NearJsonRpcClient) async {
        do {
            let response = try await client.request(method: "gas_price", params: ["block_id": "final"])
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                
                if let gasPrice = result["gas_price"] as? String {
                    print("   ✅ Gas Price: \(gasPrice) yoctoNEAR")
                    
                    // Convert to NEAR for better readability
                    if let gasPriceInt = UInt64(gasPrice) {
                        let gasPriceInNEAR = Double(gasPriceInt) / 1_000_000_000_000_000_000_000_000.0
                        print("   ✅ Gas Price: \(String(format: "%.6f", gasPriceInNEAR)) NEAR")
                    }
                }
            }
        } catch {
            print("   ❌ Failed to get gas price: \(error)")
        }
    }
    
    static func getNetworkInformation(_ client: NearJsonRpcClient) async {
        do {
            let response = try await client.request(method: "network_info")
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                
                if let activePeers = result["active_peers"] as? [[String: Any]] {
                    print("   ✅ Active Peers: \(activePeers.count)")
                    
                    // Show first few peers
                    for (index, peer) in activePeers.prefix(3).enumerated() {
                        if let accountId = peer["account_id"] as? String {
                            print("      \(index + 1). \(accountId)")
                        }
                    }
                    
                    if activePeers.count > 3 {
                        print("      ... and \(activePeers.count - 3) more peers")
                    }
                }
                
                if let numActivePeers = result["num_active_peers"] as? Int {
                    print("   ✅ Number of Active Peers: \(numActivePeers)")
                }
                
                if let peerMaxCount = result["peer_max_count"] as? Int {
                    print("   ✅ Peer Max Count: \(peerMaxCount)")
                }
                
                if let sentBytesPerSec = result["sent_bytes_per_sec"] as? Int {
                    print("   ✅ Sent Bytes/sec: \(sentBytesPerSec)")
                }
                
                if let receivedBytesPerSec = result["received_bytes_per_sec"] as? Int {
                    print("   ✅ Received Bytes/sec: \(receivedBytesPerSec)")
                }
            }
        } catch {
            print("   ❌ Failed to get network info: \(error)")
        }
    }
    
    static func getValidatorsInformation(_ client: NearJsonRpcClient) async {
        do {
            let response = try await client.request(method: "validators")
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                
                if let currentValidators = result["current_validators"] as? [[String: Any]] {
                    print("   ✅ Current Validators: \(currentValidators.count)")
                    
                    // Show first few validators with stake information
                    for (index, validator) in currentValidators.prefix(3).enumerated() {
                        if let accountId = validator["account_id"] as? String,
                           let stake = validator["stake"] as? String {
                            print("      \(index + 1). \(accountId)")
                            print("         Stake: \(stake) yoctoNEAR")
                        }
                    }
                    
                    if currentValidators.count > 3 {
                        print("      ... and \(currentValidators.count - 3) more validators")
                    }
                }
                
                if let nextValidators = result["next_validators"] as? [[String: Any]] {
                    print("   ✅ Next Validators: \(nextValidators.count)")
                }
                
                if let currentProposals = result["current_proposals"] as? [[String: Any]] {
                    print("   ✅ Current Proposals: \(currentProposals.count)")
                }
            }
        } catch {
            print("   ❌ Failed to get validators: \(error)")
        }
    }
    
    static func getGenesisConfiguration(_ client: NearJsonRpcClient) async {
        do {
            let response = try await client.request(method: "genesis_config")
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
               let result = data["result"] as? [String: Any] {
                
                if let chainId = result["chain_id"] as? String {
                    print("   ✅ Genesis Chain ID: \(chainId)")
                }
                
                if let genesisHeight = result["genesis_height"] as? Int {
                    print("   ✅ Genesis Height: \(genesisHeight)")
                }
                
                if let genesisTime = result["genesis_time"] as? String {
                    print("   ✅ Genesis Time: \(genesisTime)")
                }
                
                if let protocolVersion = result["protocol_version"] as? Int {
                    print("   ✅ Protocol Version: \(protocolVersion)")
                }
                
                if let totalSupply = result["total_supply"] as? String {
                    print("   ✅ Total Supply: \(totalSupply) yoctoNEAR")
                }
            }
        } catch {
            print("   ❌ Failed to get genesis config: \(error)")
        }
    }
    
    static func performHealthCheck(_ client: NearJsonRpcClient) async {
        do {
            let response = try await client.request(method: "health")
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                if data["result"] == nil {
                    print("   ✅ Health Check: Node is healthy")
                } else {
                    print("   ⚠️ Health Check: Node may have issues")
                }
            }
        } catch {
            print("   ❌ Health check failed: \(error)")
        }
    }
}
