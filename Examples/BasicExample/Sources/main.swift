import Foundation
import NearJsonRpcClient

@main
struct BasicExample {
    static func main() async{
        print("Testing NearJsonRpcClient")

        do{
            let client = NearRpcClient(endpoint: "https://rpc.mainnet.fastnear.com")
            print("Client created")

            let status = try await client.status()
            print("=== NEAR Network Status ===")
            print("Chain ID: \(status.chain_id)")
            print("Protocol Version: \(status.protocol_version)")
            print("Latest Protocol Version: \(status.latest_protocol_version)")
            print("Node Version: \(status.version.version)")
            print("Node Public Key: \(status.node_public_key)")
            print("Uptime: \(status.uptime_sec) seconds")
            print("Sync Status: \(status.sync_info.syncing ? "Syncing" : "Synced")")
            print("Latest Block Height: \(status.sync_info.latest_block_height)")
            print("Latest Block Hash: \(status.sync_info.latest_block_hash)")
            print("Latest Block Time: \(status.sync_info.latest_block_time)")
            print("Number of Validators: \(status.validators.count)")
            print("Genesis Hash: \(status.genesis_hash)")
            if let rpcAddr = status.rpc_addr {
                print("RPC Address: \(rpcAddr)")
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
}