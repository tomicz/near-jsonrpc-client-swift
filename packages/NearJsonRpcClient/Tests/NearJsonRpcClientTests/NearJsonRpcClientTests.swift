import XCTest
@testable import NearJsonRpcClient

final class NearJsonRpcClientTests: XCTestCase {
    func testClientInitialization() throws {
        let url = URL(string: "https://rpc.mainnet.near.org")!
        let client = NearJsonRpcClient(baseURL: url)
        XCTAssertEqual(client.url, url)
    }
    
    func testClientInitializationWithString() throws {
        let client = try NearJsonRpcClient(urlString: "https://rpc.mainnet.near.org")
        XCTAssertEqual(client.url.absoluteString, "https://rpc.mainnet.near.org")
    }
    
    func testClientInitializationWithInvalidString() throws {
        XCTAssertThrowsError(try NearJsonRpcClient(urlString: "")) { error in
            XCTAssertTrue(error is URLError)
        }
    }
}

