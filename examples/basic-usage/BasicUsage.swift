import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Basic usage example of the NEAR JSON-RPC Swift client
@main
struct BasicUsage {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Basic Usage Example")
        print("==================================================")
        
        do {
            // Initialize the client
            let client = try NearJsonRpcClient(urlString: "https://rpc.mainnet.near.org")
            print("✅ Client initialized with URL: \(client.url)")
            
            // Example 1: Get node status
            print("\n📊 Example 1: Getting node status...")
            let statusResponse = try await client.request(method: "status")
            if let statusData = try? JSONSerialization.jsonObject(with: statusResponse) as? [String: Any],
               let result = statusData["result"] as? [String: Any],
               let version = result["version"] as? [String: Any],
               let build = version["build"] as? String {
                print("   ✅ NEAR Node Version: \(build)")
            }
            
            // Example 2: Get latest block
            print("\n📦 Example 2: Getting latest block...")
            let blockResponse = try await client.request(method: "block", params: ["finality": "final"])
            if let blockData = try? JSONSerialization.jsonObject(with: blockResponse) as? [String: Any],
               let result = blockData["result"] as? [String: Any],
               let height = result["header"] as? [String: Any],
               let blockHeight = height["height"] as? Int {
                print("   ✅ Latest Block Height: \(blockHeight)")
            }
            
            // Example 3: Get gas price
            print("\n⛽ Example 3: Getting gas price...")
            let gasResponse = try await client.request(method: "gas_price", params: ["block_id": "final"])
            if let gasData = try? JSONSerialization.jsonObject(with: gasResponse) as? [String: Any],
               let result = gasData["result"] as? [String: Any],
               let gasPrice = result["gas_price"] as? String {
                print("   ✅ Gas Price: \(gasPrice) yoctoNEAR")
            }
            
            // Example 4: Get network info
            print("\n🌐 Example 4: Getting network info...")
            let networkResponse = try await client.request(method: "network_info")
            if let networkData = try? JSONSerialization.jsonObject(with: networkResponse) as? [String: Any],
               let result = networkData["result"] as? [String: Any],
               let activePeers = result["active_peers"] as? [[String: Any]] {
                print("   ✅ Active Peers: \(activePeers.count)")
            }
            
            print("\n🎉 All examples completed successfully!")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
}


