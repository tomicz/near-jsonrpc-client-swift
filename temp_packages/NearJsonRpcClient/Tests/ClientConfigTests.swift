import XCTest
@testable import NearJsonRpcClient

/// Tests for ClientConfig structure and validation
/// Validates configuration options, defaults, and edge cases for RPC client setup
class ClientConfigTests: XCTestCase {
    
    // MARK: - Basic Configuration Tests
    
    func testDefaultConfiguration() {
        // Test ClientConfig with minimal required parameters
        let config = ClientConfig(endpoint: "https://rpc.mainnet.near.org")
        
        // Verify required parameter is set
        XCTAssertEqual(config.endpoint, "https://rpc.mainnet.near.org")
        
        // Verify default values
        XCTAssertEqual(config.headers, [:], "Default headers should be empty")
        XCTAssertEqual(config.timeout, 30.0, "Default timeout should be 30 seconds")
        XCTAssertEqual(config.retries, 3, "Default retries should be 3")
    }
    
    func testCustomConfiguration() {
        // Test ClientConfig with all custom parameters
        let customHeaders = [
            "Authorization": "Bearer token123",
            "User-Agent": "MyApp/1.0",
            "X-Custom-Header": "custom-value"
        ]
        
        let config = ClientConfig(
            endpoint: "https://rpc.testnet.near.org",
            headers: customHeaders,
            timeout: 60.0,
            retries: 5
        )
        
        // Verify all custom values are set correctly
        XCTAssertEqual(config.endpoint, "https://rpc.testnet.near.org")
        XCTAssertEqual(config.headers, customHeaders)
        XCTAssertEqual(config.timeout, 60.0)
        XCTAssertEqual(config.retries, 5)
    }
    
    func testConfigurationImmutability() {
        // Test that ClientConfig properties are immutable (let properties)
        let config = ClientConfig(endpoint: "https://rpc.mainnet.near.org")
        
        // These should all be accessible as read-only properties
        let _ = config.endpoint
        let _ = config.headers
        let _ = config.timeout
        let _ = config.retries
        
        // Verify the config maintains its values
        XCTAssertEqual(config.endpoint, "https://rpc.mainnet.near.org")
    }
    
    // MARK: - Endpoint Validation Tests
    
    func testValidEndpointFormats() {
        // Test various valid endpoint formats
        let validEndpoints = [
            "https://rpc.mainnet.near.org",
            "https://rpc.testnet.near.org",
            "https://archival-rpc.mainnet.fastnear.com",
            "https://rpc.mainnet.fastnear.com",
            "http://localhost:3030",
            "https://custom-rpc.example.com:8080",
            "https://rpc.example.com/custom/path"
        ]
        
        for endpoint in validEndpoints {
            let config = ClientConfig(endpoint: endpoint)
            XCTAssertEqual(config.endpoint, endpoint, "Should accept valid endpoint: \(endpoint)")
        }
    }
    
    func testEndpointEdgeCases() {
        // Test edge cases for endpoints
        let edgeCaseEndpoints = [
            "https://rpc.near.org", // Short domain
            "https://very-long-subdomain-name.rpc.mainnet.near.org", // Long subdomain
            "https://rpc.mainnet.near.org/", // Trailing slash
            "https://127.0.0.1:3030", // IP address
            "https://[::1]:3030" // IPv6 address
        ]
        
        for endpoint in edgeCaseEndpoints {
            let config = ClientConfig(endpoint: endpoint)
            XCTAssertEqual(config.endpoint, endpoint, "Should handle edge case endpoint: \(endpoint)")
        }
    }
    
    func testEmptyEndpoint() {
        // Test empty endpoint (should be allowed at config level, validation happens at client level)
        let config = ClientConfig(endpoint: "")
        XCTAssertEqual(config.endpoint, "")
    }
    
    // MARK: - Headers Validation Tests
    
    func testEmptyHeaders() {
        // Test with explicitly empty headers
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            headers: [:]
        )
        
        XCTAssertEqual(config.headers, [:])
        XCTAssertTrue(config.headers.isEmpty)
    }
    
    func testSingleHeader() {
        // Test with single header
        let headers = ["Authorization": "Bearer token123"]
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            headers: headers
        )
        
        XCTAssertEqual(config.headers, headers)
        XCTAssertEqual(config.headers["Authorization"], "Bearer token123")
    }
    
    func testMultipleHeaders() {
        // Test with multiple headers
        let headers = [
            "Authorization": "Bearer token123",
            "User-Agent": "NearSwiftClient/1.0",
            "Content-Type": "application/json",
            "X-API-Key": "api-key-123",
            "X-Custom-Header": "custom-value"
        ]
        
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            headers: headers
        )
        
        XCTAssertEqual(config.headers, headers)
        XCTAssertEqual(config.headers.count, 5)
        
        // Verify individual headers
        XCTAssertEqual(config.headers["Authorization"], "Bearer token123")
        XCTAssertEqual(config.headers["User-Agent"], "NearSwiftClient/1.0")
        XCTAssertEqual(config.headers["Content-Type"], "application/json")
    }
    
    func testHeadersWithSpecialCharacters() {
        // Test headers with special characters and Unicode
        let headers = [
            "X-Special-Chars": "!@#$%^&*()_+-={}[]|\\:;\"'<>?,./",
            "X-Unicode": "🚀 NEAR Protocol 测试",
            "X-Empty-Value": "",
            "X-Spaces": "value with spaces"
        ]
        
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            headers: headers
        )
        
        XCTAssertEqual(config.headers, headers)
        XCTAssertEqual(config.headers["X-Special-Chars"], "!@#$%^&*()_+-={}[]|\\:;\"'<>?,./")
        XCTAssertEqual(config.headers["X-Unicode"], "🚀 NEAR Protocol 测试")
        XCTAssertEqual(config.headers["X-Empty-Value"], "")
        XCTAssertEqual(config.headers["X-Spaces"], "value with spaces")
    }
    
    // MARK: - Timeout Validation Tests
    
    func testValidTimeouts() {
        // Test various valid timeout values
        let validTimeouts: [TimeInterval] = [
            0.1,    // Very short
            1.0,    // 1 second
            5.0,    // 5 seconds
            30.0,   // Default
            60.0,   // 1 minute
            300.0,  // 5 minutes
            3600.0  // 1 hour
        ]
        
        for timeout in validTimeouts {
            let config = ClientConfig(
                endpoint: "https://rpc.mainnet.near.org",
                timeout: timeout
            )
            
            XCTAssertEqual(config.timeout, timeout, "Should accept timeout: \(timeout)")
        }
    }
    
    func testZeroTimeout() {
        // Test zero timeout (edge case)
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            timeout: 0.0
        )
        
        XCTAssertEqual(config.timeout, 0.0)
    }
    
    func testNegativeTimeout() {
        // Test negative timeout (edge case - should be allowed at config level)
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            timeout: -1.0
        )
        
        XCTAssertEqual(config.timeout, -1.0)
    }
    
    func testExtremeTimeouts() {
        // Test extreme timeout values
        let extremeTimeouts: [TimeInterval] = [
            0.001,              // 1 millisecond
            Double.greatestFiniteMagnitude, // Maximum value
            TimeInterval.infinity           // Infinity
        ]
        
        for timeout in extremeTimeouts {
            let config = ClientConfig(
                endpoint: "https://rpc.mainnet.near.org",
                timeout: timeout
            )
            
            XCTAssertEqual(config.timeout, timeout, "Should handle extreme timeout: \(timeout)")
        }
    }
    
    // MARK: - Retries Validation Tests
    
    func testValidRetryValues() {
        // Test various valid retry values
        let validRetries = [0, 1, 2, 3, 5, 10, 50, 100]
        
        for retries in validRetries {
            let config = ClientConfig(
                endpoint: "https://rpc.mainnet.near.org",
                retries: retries
            )
            
            XCTAssertEqual(config.retries, retries, "Should accept retries: \(retries)")
        }
    }
    
    func testZeroRetries() {
        // Test zero retries (no retries)
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            retries: 0
        )
        
        XCTAssertEqual(config.retries, 0)
    }
    
    func testNegativeRetries() {
        // Test negative retries (edge case - should be allowed at config level)
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            retries: -1
        )
        
        XCTAssertEqual(config.retries, -1)
    }
    
    func testExtremeRetryValues() {
        // Test extreme retry values
        let extremeRetries = [Int.max, Int.min, 1000000]
        
        for retries in extremeRetries {
            let config = ClientConfig(
                endpoint: "https://rpc.mainnet.near.org",
                retries: retries
            )
            
            XCTAssertEqual(config.retries, retries, "Should handle extreme retries: \(retries)")
        }
    }
    
    // MARK: - Configuration Combination Tests
    
    func testAllParametersCombination() {
        // Test all parameters together with various combinations
        let testCases: [(String, [String: String], TimeInterval, Int)] = [
            ("https://rpc.mainnet.near.org", [:], 30.0, 3),
            ("https://rpc.testnet.near.org", ["Auth": "token"], 60.0, 5),
            ("http://localhost:3030", ["X-Test": "value"], 10.0, 0),
            ("https://custom.rpc.com", ["A": "1", "B": "2"], 120.0, 10)
        ]
        
        for (endpoint, headers, timeout, retries) in testCases {
            let config = ClientConfig(
                endpoint: endpoint,
                headers: headers,
                timeout: timeout,
                retries: retries
            )
            
            XCTAssertEqual(config.endpoint, endpoint)
            XCTAssertEqual(config.headers, headers)
            XCTAssertEqual(config.timeout, timeout)
            XCTAssertEqual(config.retries, retries)
        }
    }
    
    func testConfigurationConsistency() {
        // Test that configuration remains consistent after creation
        let headers = ["Authorization": "Bearer token"]
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            headers: headers,
            timeout: 45.0,
            retries: 7
        )
        
        // Verify values multiple times
        for _ in 0..<5 {
            XCTAssertEqual(config.endpoint, "https://rpc.mainnet.near.org")
            XCTAssertEqual(config.headers, headers)
            XCTAssertEqual(config.timeout, 45.0)
            XCTAssertEqual(config.retries, 7)
        }
    }
    
    // MARK: - Real-world Configuration Tests
    
    func testMainnetConfiguration() {
        // Test typical mainnet configuration
        let config = ClientConfig(
            endpoint: "https://rpc.mainnet.near.org",
            headers: ["User-Agent": "MyDApp/1.0"],
            timeout: 30.0,
            retries: 3
        )
        
        XCTAssertEqual(config.endpoint, "https://rpc.mainnet.near.org")
        XCTAssertEqual(config.headers["User-Agent"], "MyDApp/1.0")
        XCTAssertEqual(config.timeout, 30.0)
        XCTAssertEqual(config.retries, 3)
    }
    
    func testTestnetConfiguration() {
        // Test typical testnet configuration
        let config = ClientConfig(
            endpoint: "https://rpc.testnet.near.org",
            headers: [:],
            timeout: 60.0,
            retries: 5
        )
        
        XCTAssertEqual(config.endpoint, "https://rpc.testnet.near.org")
        XCTAssertTrue(config.headers.isEmpty)
        XCTAssertEqual(config.timeout, 60.0)
        XCTAssertEqual(config.retries, 5)
    }
    
    func testArchivalConfiguration() {
        // Test archival RPC configuration
        let config = ClientConfig(
            endpoint: "https://archival-rpc.mainnet.fastnear.com",
            headers: ["X-API-Key": "archival-key"],
            timeout: 120.0,
            retries: 2
        )
        
        XCTAssertEqual(config.endpoint, "https://archival-rpc.mainnet.fastnear.com")
        XCTAssertEqual(config.headers["X-API-Key"], "archival-key")
        XCTAssertEqual(config.timeout, 120.0)
        XCTAssertEqual(config.retries, 2)
    }
    
    func testLocalDevelopmentConfiguration() {
        // Test local development configuration
        let config = ClientConfig(
            endpoint: "http://localhost:3030",
            headers: ["X-Debug": "true"],
            timeout: 5.0,
            retries: 1
        )
        
        XCTAssertEqual(config.endpoint, "http://localhost:3030")
        XCTAssertEqual(config.headers["X-Debug"], "true")
        XCTAssertEqual(config.timeout, 5.0)
        XCTAssertEqual(config.retries, 1)
    }
    
    // MARK: - Performance Tests
    
    func testConfigurationCreationPerformance() {
        // Test performance of creating many configurations
        measure {
            for i in 0..<1000 {
                let config = ClientConfig(
                    endpoint: "https://rpc.mainnet.near.org",
                    headers: ["X-Test": "test-\(i)"],
                    timeout: Double(i % 100),
                    retries: i % 10
                )
                
                // Force evaluation
                let _ = config.endpoint
                let _ = config.headers
                let _ = config.timeout
                let _ = config.retries
            }
        }
    }
}
