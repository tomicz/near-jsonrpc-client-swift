import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Comprehensive error handling examples for NEAR JSON-RPC Swift client
/// This demonstrates various error scenarios and how to handle them gracefully
@main
struct ErrorHandlingExamples {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Error Handling Examples")
        print("=======================================================")
        
        do {
            // Initialize the client for testnet
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with Testnet URL: \(client.url)")
            
            // Example 1: Handle invalid method errors
            print("\n❌ Example 1: Handling invalid method errors...")
            await handleInvalidMethodError(client)
            
            // Example 2: Handle invalid parameters
            print("\n❌ Example 2: Handling invalid parameters...")
            await handleInvalidParameters(client)
            
            // Example 3: Handle network errors
            print("\n❌ Example 3: Handling network errors...")
            await handleNetworkErrors()
            
            // Example 4: Handle account not found errors
            print("\n❌ Example 4: Handling account not found errors...")
            await handleAccountNotFoundError(client)
            
            // Example 5: Handle transaction errors
            print("\n❌ Example 5: Handling transaction errors...")
            await handleTransactionErrors(client)
            
            // Example 6: Handle contract errors
            print("\n❌ Example 6: Handling contract errors...")
            await handleContractErrors(client)
            
            // Example 7: Retry patterns
            print("\n🔄 Example 7: Implementing retry patterns...")
            await demonstrateRetryPatterns(client)
            
            // Example 8: Graceful degradation
            print("\n🛡️ Example 8: Implementing graceful degradation...")
            await demonstrateGracefulDegradation(client)
            
            print("\n🎉 All error handling examples completed successfully!")
            print("\n💡 Key takeaways:")
            print("   ✅ Comprehensive error handling patterns")
            print("   ✅ Network error recovery")
            print("   ✅ Retry mechanisms")
            print("   ✅ Graceful degradation strategies")
            print("   ✅ User-friendly error messages")
            print("   ✅ Logging and debugging information")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Error Handling Examples
    
    static func handleInvalidMethodError(_ client: NearJsonRpcClient) async {
        do {
            // Try to call a non-existent method
            let response = try await client.request(method: "invalid_method")
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                if let error = data["error"] as? [String: Any] {
                    let errorCode = error["code"] as? Int ?? -1
                    let errorMessage = error["message"] as? String ?? "Unknown error"
                    
                    print("   ❌ RPC Error caught:")
                    print("      Code: \(errorCode)")
                    print("      Message: \(errorMessage)")
                    
                    // Handle specific error codes
                    switch errorCode {
                    case -32601:
                        print("      💡 This is a 'Method not found' error")
                        print("      💡 Check the method name and ensure it's supported")
                    case -32602:
                        print("      💡 This is an 'Invalid params' error")
                        print("      💡 Check the parameters being passed")
                    default:
                        print("      💡 This is an unknown RPC error")
                    }
                } else {
                    print("   ✅ Unexpected success for invalid method")
                }
            }
        } catch {
            print("   ❌ Client error: \(error)")
            print("   💡 This could be a network or parsing error")
        }
    }
    
    static func handleInvalidParameters(_ client: NearJsonRpcClient) async {
        do {
            // Try to call a method with invalid parameters
            let response = try await client.request(
                method: "block",
                params: ["invalid_param": "invalid_value"]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                if let error = data["error"] as? [String: Any] {
                    let errorCode = error["code"] as? Int ?? -1
                    let errorMessage = error["message"] as? String ?? "Unknown error"
                    
                    print("   ❌ Parameter Error caught:")
                    print("      Code: \(errorCode)")
                    print("      Message: \(errorMessage)")
                    
                    if let data = error["data"] as? [String: Any] {
                        print("      Data: \(data)")
                    }
                } else {
                    print("   ✅ Unexpected success for invalid parameters")
                }
            }
        } catch {
            print("   ❌ Client error: \(error)")
        }
    }
    
    static func handleNetworkErrors() async {
        do {
            // Try to connect to an invalid URL
            let invalidClient = try NearJsonRpcClient(urlString: "https://invalid-url-that-does-not-exist.com")
            let response = try await invalidClient.request(method: "status")
            
            print("   ✅ Unexpected success for invalid URL")
        } catch {
            print("   ❌ Network Error caught:")
            print("      Error: \(error)")
            
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    print("      💡 No internet connection")
                case .timedOut:
                    print("      💡 Request timed out")
                case .cannotFindHost:
                    print("      💡 Host not found")
                case .cannotConnectToHost:
                    print("      💡 Cannot connect to host")
                default:
                    print("      💡 Other network error: \(urlError.localizedDescription)")
                }
            }
        }
    }
    
    static func handleAccountNotFoundError(_ client: NearJsonRpcClient) async {
        do {
            // Try to query a non-existent account
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "view_account",
                    "finality": "final",
                    "account_id": "this-account-definitely-does-not-exist-12345.testnet"
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                if let error = data["error"] as? [String: Any] {
                    let errorCode = error["code"] as? Int ?? -1
                    let errorMessage = error["message"] as? String ?? "Unknown error"
                    
                    print("   ❌ Account Error caught:")
                    print("      Code: \(errorCode)")
                    print("      Message: \(errorMessage)")
                    
                    if errorMessage.contains("does not exist") {
                        print("      💡 Account does not exist")
                        print("      💡 Check the account ID spelling")
                        print("      💡 Ensure the account is on the correct network")
                    }
                } else {
                    print("   ✅ Unexpected success for non-existent account")
                }
            }
        } catch {
            print("   ❌ Client error: \(error)")
        }
    }
    
    static func handleTransactionErrors(_ client: NearJsonRpcClient) async {
        do {
            // Try to get status of a non-existent transaction
            let response = try await client.request(
                method: "tx",
                params: [
                    "tx_hash": "invalid-transaction-hash-that-does-not-exist",
                    "sender_account_id": "example.testnet"
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                if let error = data["error"] as? [String: Any] {
                    let errorCode = error["code"] as? Int ?? -1
                    let errorMessage = error["message"] as? String ?? "Unknown error"
                    
                    print("   ❌ Transaction Error caught:")
                    print("      Code: \(errorCode)")
                    print("      Message: \(errorMessage)")
                    
                    if errorMessage.contains("not found") {
                        print("      💡 Transaction not found")
                        print("      💡 Check the transaction hash")
                        print("      💡 Ensure the transaction exists on this network")
                    }
                } else {
                    print("   ✅ Unexpected success for non-existent transaction")
                }
            }
        } catch {
            print("   ❌ Client error: \(error)")
        }
    }
    
    static func handleContractErrors(_ client: NearJsonRpcClient) async {
        do {
            // Try to call a function on a non-existent contract
            let response = try await client.request(
                method: "query",
                params: [
                    "request_type": "call_function",
                    "finality": "final",
                    "account_id": "non-existent-contract.testnet",
                    "method_name": "some_method",
                    "args_base64": "e30=" // Empty JSON object
                ]
            )
            
            if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                if let error = data["error"] as? [String: Any] {
                    let errorCode = error["code"] as? Int ?? -1
                    let errorMessage = error["message"] as? String ?? "Unknown error"
                    
                    print("   ❌ Contract Error caught:")
                    print("      Code: \(errorCode)")
                    print("      Message: \(errorMessage)")
                    
                    if errorMessage.contains("does not exist") {
                        print("      💡 Contract does not exist")
                        print("      💡 Check the contract ID")
                        print("      💡 Ensure the contract is deployed")
                    } else if errorMessage.contains("method") {
                        print("      💡 Method does not exist on contract")
                        print("      💡 Check the method name")
                        print("      💡 Ensure the method is public")
                    }
                } else {
                    print("   ✅ Unexpected success for non-existent contract")
                }
            }
        } catch {
            print("   ❌ Client error: \(error)")
        }
    }
    
    static func demonstrateRetryPatterns(_ client: NearJsonRpcClient) async {
        print("   🔄 Demonstrating retry patterns...")
        
        // Example retry function
        func retryRequest<T>(
            maxRetries: Int = 3,
            delay: TimeInterval = 1.0,
            operation: @escaping () async throws -> T
        ) async throws -> T {
            var lastError: Error?
            
            for attempt in 1...maxRetries {
                do {
                    return try await operation()
                } catch {
                    lastError = error
                    print("      Attempt \(attempt) failed: \(error)")
                    
                    if attempt < maxRetries {
                        print("      Retrying in \(delay) seconds...")
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    }
                }
            }
            
            throw lastError ?? NSError(domain: "RetryError", code: -1, userInfo: [NSLocalizedDescriptionKey: "All retry attempts failed"])
        }
        
        do {
            // Use retry pattern for a potentially flaky request
            let result = try await retryRequest(maxRetries: 3, delay: 0.5) {
                try await client.request(method: "status")
            }
            
            print("   ✅ Request succeeded after retries")
            print("   ✅ Response size: \(result.count) bytes")
            
        } catch {
            print("   ❌ Request failed after all retries: \(error)")
        }
    }
    
    static func demonstrateGracefulDegradation(_ client: NearJsonRpcClient) async {
        print("   🛡️ Demonstrating graceful degradation...")
        
        // Try multiple fallback strategies
        let strategies = [
            ("Primary", "https://rpc.testnet.near.org"),
            ("Fallback 1", "https://rpc.testnet.fastnear.com"),
            ("Fallback 2", "https://testnet-rpc.near.org")
        ]
        
        for (name, url) in strategies {
            do {
                print("   🔄 Trying \(name): \(url)")
                let fallbackClient = try NearJsonRpcClient(urlString: url)
                let response = try await fallbackClient.request(method: "status")
                
                if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any],
                   let result = data["result"] as? [String: Any],
                   let chainId = result["chain_id"] as? String {
                    print("   ✅ \(name) succeeded!")
                    print("   ✅ Chain ID: \(chainId)")
                    return
                }
            } catch {
                print("   ❌ \(name) failed: \(error)")
                continue
            }
        }
        
        print("   ❌ All fallback strategies failed")
        print("   💡 Consider implementing offline mode or cached data")
    }
}
