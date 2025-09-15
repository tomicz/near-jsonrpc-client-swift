import Foundation
import NearJsonRpcClient
import NearJsonRpcTypes

/// Comprehensive validation examples for NEAR JSON-RPC Swift client
/// This demonstrates input validation, parameter validation, and response validation
@main
struct ValidationExamples {
    static func main() async {
        print("🚀 NEAR JSON-RPC Swift Client - Validation Examples")
        print("==================================================")
        
        do {
            // Initialize the client for testnet
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            print("✅ Client initialized with Testnet URL: \(client.url)")
            
            // Example 1: Method validation
            print("\n✅ Example 1: RPC method validation...")
            await validateRpcMethods()
            
            // Example 2: Parameter validation
            print("\n✅ Example 2: Parameter validation...")
            await validateParameters(client)
            
            // Example 3: Account ID validation
            print("\n✅ Example 3: Account ID validation...")
            await validateAccountIds()
            
            // Example 4: Block ID validation
            print("\n✅ Example 4: Block ID validation...")
            await validateBlockIds()
            
            // Example 5: Transaction hash validation
            print("\n✅ Example 5: Transaction hash validation...")
            await validateTransactionHashes()
            
            // Example 6: Response validation
            print("\n✅ Example 6: Response validation...")
            await validateResponses(client)
            
            // Example 7: Input sanitization
            print("\n✅ Example 7: Input sanitization...")
            await demonstrateInputSanitization()
            
            // Example 8: Type validation
            print("\n✅ Example 8: Type validation...")
            await demonstrateTypeValidation()
            
            print("\n🎉 All validation examples completed successfully!")
            print("\n💡 Key takeaways:")
            print("   ✅ Comprehensive input validation")
            print("   ✅ Parameter validation patterns")
            print("   ✅ Response validation strategies")
            print("   ✅ Type safety enforcement")
            print("   ✅ Security best practices")
            print("   ✅ Error prevention techniques")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Validation Examples
    
    static func validateRpcMethods() async {
        print("   🔍 Validating RPC methods...")
        
        let validMethods = [
            "status", "block", "gas_price", "query", "validators",
            "network_info", "health", "genesis_config", "client_config"
        ]
        
        let invalidMethods = [
            "invalid_method", "block_invalid", "status_", "_query",
            "method with spaces", "method-with-dashes", "method.with.dots"
        ]
        
        // Test valid methods
        for method in validMethods {
            let isValid = RpcMethodValidator.isValid(method)
            print("   ✅ '\(method)': \(isValid ? "Valid" : "Invalid")")
        }
        
        // Test invalid methods
        for method in invalidMethods {
            let isValid = RpcMethodValidator.isValid(method)
            print("   ❌ '\(method)': \(isValid ? "Valid" : "Invalid")")
        }
        
        // Test experimental methods
        let experimentalMethods = RpcMethodValidator.experimentalMethods()
        print("   🧪 Experimental methods: \(experimentalMethods.count)")
        for method in experimentalMethods.prefix(3) {
            print("      - \(method)")
        }
        
        // Test stable methods
        let stableMethods = RpcMethodValidator.stableMethods()
        print("   🏗️ Stable methods: \(stableMethods.count)")
    }
    
    static func validateParameters(_ client: NearJsonRpcClient) async {
        print("   🔍 Validating method parameters...")
        
        // Test valid parameters
        let validParams = [
            "status": [:],
            "block": ["finality": "final"],
            "gas_price": ["block_id": "final"],
            "query": [
                "request_type": "view_account",
                "finality": "final",
                "account_id": "example.testnet"
            ]
        ]
        
        for (method, params) in validParams {
            do {
                let response = try await client.request(method: method, params: params)
                if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                    if data["error"] == nil {
                        print("   ✅ '\(method)' with valid params: Success")
                    } else {
                        print("   ⚠️ '\(method)' with valid params: RPC Error")
                    }
                }
            } catch {
                print("   ❌ '\(method)' with valid params: \(error)")
            }
        }
        
        // Test invalid parameters
        let invalidParams = [
            "status": ["invalid_param": "value"],
            "block": ["invalid_finality": "invalid"],
            "gas_price": ["invalid_block_id": "invalid"],
            "query": ["invalid_request_type": "invalid"]
        ]
        
        for (method, params) in invalidParams {
            do {
                let response = try await client.request(method: method, params: params)
                if let data = try? JSONSerialization.jsonObject(with: response) as? [String: Any] {
                    if let error = data["error"] as? [String: Any] {
                        print("   ❌ '\(method)' with invalid params: \(error["message"] as? String ?? "Unknown error")")
                    } else {
                        print("   ⚠️ '\(method)' with invalid params: Unexpected success")
                    }
                }
            } catch {
                print("   ❌ '\(method)' with invalid params: \(error)")
            }
        }
    }
    
    static func validateAccountIds() async {
        print("   🔍 Validating account IDs...")
        
        let validAccountIds = [
            "example.testnet",
            "alice.near",
            "bob.testnet",
            "contract.mainnet",
            "user123.testnet",
            "a" + String(repeating: "b", count: 63) + ".testnet" // 64 char limit
        ]
        
        let invalidAccountIds = [
            "", // Empty
            "invalid", // No suffix
            "user@domain.com", // Invalid characters
            "user with spaces.testnet", // Spaces
            "user-with-dashes.testnet", // Dashes
            "user.with.dots.testnet", // Multiple dots
            String(repeating: "a", count: 65) + ".testnet", // Too long
            ".testnet", // Starts with dot
            "user.", // Ends with dot
            "user..testnet" // Double dots
        ]
        
        // Test valid account IDs
        for accountId in validAccountIds {
            let isValid = isValidAccountId(accountId)
            print("   ✅ '\(accountId)': \(isValid ? "Valid" : "Invalid")")
        }
        
        // Test invalid account IDs
        for accountId in invalidAccountIds {
            let isValid = isValidAccountId(accountId)
            print("   ❌ '\(accountId)': \(isValid ? "Valid" : "Invalid")")
        }
    }
    
    static func validateBlockIds() async {
        print("   🔍 Validating block IDs...")
        
        let validBlockIds = [
            "final",
            "optimistic",
            "near_final",
            "12345", // Block height
            "11111111111111111111111111111111", // Block hash
            "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt" // Real block hash
        ]
        
        let invalidBlockIds = [
            "", // Empty
            "invalid", // Invalid finality
            "123abc", // Mixed alphanumeric
            "block_hash_with_spaces", // Spaces
            "block-hash-with-dashes", // Dashes
            "block.hash.with.dots" // Dots
        ]
        
        // Test valid block IDs
        for blockId in validBlockIds {
            let isValid = isValidBlockId(blockId)
            print("   ✅ '\(blockId)': \(isValid ? "Valid" : "Invalid")")
        }
        
        // Test invalid block IDs
        for blockId in invalidBlockIds {
            let isValid = isValidBlockId(blockId)
            print("   ❌ '\(blockId)': \(isValid ? "Valid" : "Invalid")")
        }
    }
    
    static func validateTransactionHashes() async {
        print("   🔍 Validating transaction hashes...")
        
        let validTxHashes = [
            "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt",
            "11111111111111111111111111111111",
            "22222222222222222222222222222222",
            "33333333333333333333333333333333"
        ]
        
        let invalidTxHashes = [
            "", // Empty
            "invalid", // Too short
            "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt_invalid", // Too long
            "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt ", // Trailing space
            " 5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt", // Leading space
            "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt@", // Invalid character
            "5XJqk3ZbFidioxkSBVvWwEQNvqmWe5fWT5tgB7GYsapt-", // Invalid character
        ]
        
        // Test valid transaction hashes
        for txHash in validTxHashes {
            let isValid = isValidTransactionHash(txHash)
            print("   ✅ '\(txHash)': \(isValid ? "Valid" : "Invalid")")
        }
        
        // Test invalid transaction hashes
        for txHash in invalidTxHashes {
            let isValid = isValidTransactionHash(txHash)
            print("   ❌ '\(txHash)': \(isValid ? "Valid" : "Invalid")")
        }
    }
    
    static func validateResponses(_ client: NearJsonRpcClient) async {
        print("   🔍 Validating response structures...")
        
        do {
            // Test status response validation
            let statusResponse = try await client.request(method: "status")
            if let data = try? JSONSerialization.jsonObject(with: statusResponse) as? [String: Any] {
                let isValid = validateStatusResponse(data)
                print("   ✅ Status response: \(isValid ? "Valid" : "Invalid")")
                
                if let result = data["result"] as? [String: Any] {
                    print("      - Chain ID: \(result["chain_id"] != nil ? "Present" : "Missing")")
                    print("      - Version: \(result["version"] != nil ? "Present" : "Missing")")
                    print("      - Sync Info: \(result["sync_info"] != nil ? "Present" : "Missing")")
                }
            }
            
            // Test block response validation
            let blockResponse = try await client.request(method: "block", params: ["finality": "final"])
            if let data = try? JSONSerialization.jsonObject(with: blockResponse) as? [String: Any] {
                let isValid = validateBlockResponse(data)
                print("   ✅ Block response: \(isValid ? "Valid" : "Invalid")")
                
                if let result = data["result"] as? [String: Any] {
                    print("      - Header: \(result["header"] != nil ? "Present" : "Missing")")
                    print("      - Chunks: \(result["chunks"] != nil ? "Present" : "Missing")")
                    print("      - Transactions: \(result["transactions"] != nil ? "Present" : "Missing")")
                }
            }
            
        } catch {
            print("   ❌ Response validation failed: \(error)")
        }
    }
    
    static func demonstrateInputSanitization() async {
        print("   🔍 Demonstrating input sanitization...")
        
        let inputs = [
            "  example.testnet  ", // Leading/trailing spaces
            "EXAMPLE.TESTNET", // Uppercase
            "example.testnet\n", // Newline
            "example.testnet\t", // Tab
            "example.testnet\r", // Carriage return
            "example.testnet\u{0}", // Null character
            "example.testnet<script>", // HTML tags
            "example.testnet' OR 1=1--", // SQL injection attempt
        ]
        
        for input in inputs {
            let sanitized = sanitizeInput(input)
            print("   🔧 '\(input)' → '\(sanitized)'")
        }
    }
    
    static func demonstrateTypeValidation() async {
        print("   🔍 Demonstrating type validation...")
        
        // Test various data types
        let testData: [String: Any] = [
            "string": "example.testnet",
            "number": 12345,
            "boolean": true,
            "array": ["item1", "item2"],
            "object": ["key": "value"],
            "null": NSNull()
        ]
        
        for (key, value) in testData {
            let type = getTypeDescription(value)
            print("   📝 '\(key)': \(type)")
        }
        
        // Test type conversion
        let stringValue = "12345"
        if let intValue = Int(stringValue) {
            print("   🔄 String '\(stringValue)' → Int \(intValue)")
        }
        
        let numberValue = 12345
        let stringFromNumber = String(numberValue)
        print("   🔄 Int \(numberValue) → String '\(stringFromNumber)'")
    }
    
    // MARK: - Validation Helper Functions
    
    static func isValidAccountId(_ accountId: String) -> Bool {
        // Basic account ID validation
        guard !accountId.isEmpty,
              accountId.count <= 64,
              !accountId.hasPrefix("."),
              !accountId.hasSuffix("."),
              !accountId.contains("..") else {
            return false
        }
        
        // Check for valid characters (alphanumeric, dots, underscores, dashes)
        let validCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "._-"))
        return accountId.rangeOfCharacter(from: validCharacters.inverted) == nil
    }
    
    static func isValidBlockId(_ blockId: String) -> Bool {
        // Check for valid finality values
        let validFinalities = ["final", "optimistic", "near_final"]
        if validFinalities.contains(blockId) {
            return true
        }
        
        // Check for numeric block height
        if let _ = Int(blockId) {
            return true
        }
        
        // Check for valid block hash format (base58, 32 bytes = 44 characters)
        if blockId.count == 44 && blockId.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil {
            return true
        }
        
        return false
    }
    
    static func isValidTransactionHash(_ txHash: String) -> Bool {
        // Transaction hash should be base58 encoded, typically 44 characters
        guard txHash.count == 44,
              txHash.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil else {
            return false
        }
        
        return true
    }
    
    static func validateStatusResponse(_ data: [String: Any]) -> Bool {
        guard let result = data["result"] as? [String: Any] else {
            return false
        }
        
        // Check for required fields
        let requiredFields = ["chain_id", "version", "sync_info"]
        for field in requiredFields {
            guard result[field] != nil else {
                return false
            }
        }
        
        return true
    }
    
    static func validateBlockResponse(_ data: [String: Any]) -> Bool {
        guard let result = data["result"] as? [String: Any] else {
            return false
        }
        
        // Check for required fields
        let requiredFields = ["header"]
        for field in requiredFields {
            guard result[field] != nil else {
                return false
            }
        }
        
        return true
    }
    
    static func sanitizeInput(_ input: String) -> String {
        return input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: "\0", with: "")
            .lowercased()
    }
    
    static func getTypeDescription(_ value: Any) -> String {
        switch value {
        case is String:
            return "String"
        case is Int:
            return "Int"
        case is Double:
            return "Double"
        case is Bool:
            return "Bool"
        case is [Any]:
            return "Array"
        case is [String: Any]:
            return "Dictionary"
        case is NSNull:
            return "Null"
        default:
            return "Unknown"
        }
    }
}
