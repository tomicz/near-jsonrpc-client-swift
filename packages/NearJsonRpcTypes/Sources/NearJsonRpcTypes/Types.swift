// Auto-generated Swift types from NEAR OpenAPI spec
// Generated on: 2025-01-27
// Do not edit manually - run 'swift package generate' to regenerate

import Foundation

// MARK: - JSON-RPC Protocol Types

/// Standard JSON-RPC 2.0 request structure
public struct JsonRpcRequest: Codable, Sendable {
    public let jsonrpc: String
    public let id: String
    public let method: String
    public let params: [String: AnyCodable]?
    
    public init(id: String, method: String, params: [String: AnyCodable]? = nil) {
        self.jsonrpc = "2.0"
        self.id = id
        self.method = method
        self.params = params
    }
}

/// Standard JSON-RPC 2.0 response structure
public struct JsonRpcResponse<T: Codable & Sendable>: Codable, Sendable {
    public let jsonrpc: String
    public let id: String
    public let result: T?
    public let error: RpcError?
    
    public init(id: String, result: T? = nil, error: RpcError? = nil) {
        self.jsonrpc = "2.0"
        self.id = id
        self.result = result
        self.error = error
    }
}

/// JSON-RPC error structure
public struct RpcError: Codable, Sendable {
    public let code: Int
    public let message: String
    public let data: AnyCodable?
    
    public init(code: Int, message: String, data: AnyCodable? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - NEAR Protocol Core Types

/// NEAR account identifier
public typealias AccountId = String

/// NEAR public key (base58 encoded)
public typealias PublicKey = String

/// NEAR signature (base58 encoded)
public typealias Signature = String

/// NEAR block hash
public typealias BlockHash = String

/// NEAR transaction hash
public typealias TransactionHash = String

/// NEAR chunk hash
public typealias ChunkHash = String

/// NEAR crypto hash
public typealias CryptoHash = String

/// NEAR gas price
public typealias GasPrice = String

/// NEAR balance (in yoctoNEAR)
public typealias Balance = String

/// NEAR gas units
public typealias Gas = UInt64

/// NEAR block height
public typealias BlockHeight = UInt64

/// NEAR epoch ID
public typealias EpochId = String

/// NEAR shard ID
public typealias ShardId = UInt64

// MARK: - Account Types

/// Access key provides limited access to an account
public struct AccessKey: Codable, Sendable {
    public let nonce: UInt64
    public let permission: AccessKeyPermission
    
    public init(nonce: UInt64, permission: AccessKeyPermission) {
        self.nonce = nonce
        self.permission = permission
    }
}

/// Defines permissions for AccessKey
public enum AccessKeyPermission: Codable, Sendable {
    case fullAccess
    case functionCall(FunctionCallPermission)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            if string == "FullAccess" {
                self = .fullAccess
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermission")
            }
        } else {
            let functionCall = try container.decode(FunctionCallPermission.self)
            self = .functionCall(functionCall)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .fullAccess:
            try container.encode("FullAccess")
        case .functionCall(let permission):
            try container.encode(permission)
        }
    }
}

/// Function call permission for access keys
public struct FunctionCallPermission: Codable, Sendable {
    public let allowance: Balance?
    public let receiverId: AccountId
    public let methodNames: [String]
    
    public init(allowance: Balance? = nil, receiverId: AccountId, methodNames: [String]) {
        self.allowance = allowance
        self.receiverId = receiverId
        self.methodNames = methodNames
    }
}

/// Describes access key permission scope and nonce
public struct AccessKeyView: Codable, Sendable {
    public let nonce: UInt64
    public let permission: AccessKeyPermissionView
    
    public init(nonce: UInt64, permission: AccessKeyPermissionView) {
        self.nonce = nonce
        self.permission = permission
    }
}

/// Describes the permission scope for an access key
public enum AccessKeyPermissionView: Codable, Sendable {
    case fullAccess
    case functionCall(FunctionCallPermissionView)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            if string == "FullAccess" {
                self = .fullAccess
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermissionView")
            }
        } else {
            let functionCall = try container.decode(FunctionCallPermissionView.self)
            self = .functionCall(functionCall)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .fullAccess:
            try container.encode("FullAccess")
        case .functionCall(let permission):
            try container.encode(permission)
        }
    }
}

/// Function call permission view
public struct FunctionCallPermissionView: Codable, Sendable {
    public let allowance: Balance?
    public let receiverId: AccountId
    public let methodNames: [String]
    
    public init(allowance: Balance? = nil, receiverId: AccountId, methodNames: [String]) {
        self.allowance = allowance
        self.receiverId = receiverId
        self.methodNames = methodNames
    }
}

/// Account information
public struct AccountView: Codable, Sendable {
    public let amount: Balance
    public let locked: Balance
    public let codeHash: CryptoHash
    public let storageUsage: UInt64
    public let storagePaidAt: UInt64
    public let blockHeight: BlockHeight
    public let blockHash: BlockHash
    
    public init(amount: Balance, locked: Balance, codeHash: CryptoHash, storageUsage: UInt64, storagePaidAt: UInt64, blockHeight: BlockHeight, blockHash: BlockHash) {
        self.amount = amount
        self.locked = locked
        self.codeHash = codeHash
        self.storageUsage = storageUsage
        self.storagePaidAt = storagePaidAt
        self.blockHeight = blockHeight
        self.blockHash = blockHash
    }
}

// MARK: - Block Types

/// Block identifier - can be either block hash or block height
public enum BlockId: Codable, Sendable {
    case hash(BlockHash)
    case height(BlockHeight)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let hash = try? container.decode(BlockHash.self) {
            self = .hash(hash)
        } else if let height = try? container.decode(BlockHeight.self) {
            self = .height(height)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid BlockId")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .hash(let hash):
            try container.encode(hash)
        case .height(let height):
            try container.encode(height)
        }
    }
}

/// Finality type for queries
public enum Finality: String, Codable, Sendable {
    case optimistic = "optimistic"
    case nearFinal = "near_final"
    case final = "final"
}

/// Block header information
public struct BlockHeader: Codable, Sendable {
    public let height: BlockHeight
    public let epochId: EpochId
    public let nextEpochId: EpochId
    public let hash: BlockHash
    public let prevHash: BlockHash
    public let prevStateRoot: CryptoHash
    public let chunkReceiptsRoot: CryptoHash
    public let chunkHeadersRoot: CryptoHash
    public let chunkTxRoot: CryptoHash
    public let outcomeRoot: CryptoHash
    public let chunksIncluded: UInt64
    public let challengesRoot: CryptoHash
    public let timestamp: UInt64
    public let timestampNanosec: String
    public let randomValue: CryptoHash
    public let validatorProposals: [ValidatorStakeView]
    public let chunkMask: [Bool]
    public let gasPrice: Balance
    public let blockOrdinal: UInt64?
    public let totalSupply: Balance
    public let challengesResult: [SlashedValidator]
    public let lastFinalBlock: BlockHash
    public let lastDsFinalBlock: BlockHash?
    public let nextBpHash: BlockHash
    public let blockMerkleRoot: CryptoHash
    public let epochSyncDataHash: CryptoHash?
    public let approvals: [Signature?]
    public let signature: Signature
    public let latestProtocolVersion: UInt32
    
    public init(height: BlockHeight, epochId: EpochId, nextEpochId: EpochId, hash: BlockHash, prevHash: BlockHash, prevStateRoot: CryptoHash, chunkReceiptsRoot: CryptoHash, chunkHeadersRoot: CryptoHash, chunkTxRoot: CryptoHash, outcomeRoot: CryptoHash, chunksIncluded: UInt64, challengesRoot: CryptoHash, timestamp: UInt64, timestampNanosec: String, randomValue: CryptoHash, validatorProposals: [ValidatorStakeView], chunkMask: [Bool], gasPrice: Balance, blockOrdinal: UInt64?, totalSupply: Balance, challengesResult: [SlashedValidator], lastFinalBlock: BlockHash, lastDsFinalBlock: BlockHash?, nextBpHash: BlockHash, blockMerkleRoot: CryptoHash, epochSyncDataHash: CryptoHash?, approvals: [Signature?], signature: Signature, latestProtocolVersion: UInt32) {
        self.height = height
        self.epochId = epochId
        self.nextEpochId = nextEpochId
        self.hash = hash
        self.prevHash = prevHash
        self.prevStateRoot = prevStateRoot
        self.chunkReceiptsRoot = chunkReceiptsRoot
        self.chunkHeadersRoot = chunkHeadersRoot
        self.chunkTxRoot = chunkTxRoot
        self.outcomeRoot = outcomeRoot
        self.chunksIncluded = chunksIncluded
        self.challengesRoot = challengesRoot
        self.timestamp = timestamp
        self.timestampNanosec = timestampNanosec
        self.randomValue = randomValue
        self.validatorProposals = validatorProposals
        self.chunkMask = chunkMask
        self.gasPrice = gasPrice
        self.blockOrdinal = blockOrdinal
        self.totalSupply = totalSupply
        self.challengesResult = challengesResult
        self.lastFinalBlock = lastFinalBlock
        self.lastDsFinalBlock = lastDsFinalBlock
        self.nextBpHash = nextBpHash
        self.blockMerkleRoot = blockMerkleRoot
        self.epochSyncDataHash = epochSyncDataHash
        self.approvals = approvals
        self.signature = signature
        self.latestProtocolVersion = latestProtocolVersion
    }
}

// MARK: - Validator Types

/// Validator stake information
public struct ValidatorStakeView: Codable, Sendable {
    public let accountId: AccountId
    public let publicKey: PublicKey
    public let stake: Balance
    public let validatorStakeStructVersion: String
    
    public init(accountId: AccountId, publicKey: PublicKey, stake: Balance, validatorStakeStructVersion: String) {
        self.accountId = accountId
        self.publicKey = publicKey
        self.stake = stake
        self.validatorStakeStructVersion = validatorStakeStructVersion
    }
}

/// Slashed validator information
public struct SlashedValidator: Codable, Sendable {
    public let accountId: AccountId
    public let isDoubleSign: Bool
    
    public init(accountId: AccountId, isDoubleSign: Bool) {
        self.accountId = accountId
        self.isDoubleSign = isDoubleSign
    }
}

// MARK: - Transaction Types

/// Transaction information
public struct Transaction: Codable, Sendable {
    public let signerId: AccountId
    public let publicKey: PublicKey
    public let nonce: UInt64
    public let receiverId: AccountId
    public let actions: [Action]
    public let signature: Signature
    public let hash: TransactionHash
    
    public init(signerId: AccountId, publicKey: PublicKey, nonce: UInt64, receiverId: AccountId, actions: [Action], signature: Signature, hash: TransactionHash) {
        self.signerId = signerId
        self.publicKey = publicKey
        self.nonce = nonce
        self.receiverId = receiverId
        self.actions = actions
        self.signature = signature
        self.hash = hash
    }
}

/// Transaction action
public enum Action: Codable, Sendable {
    case createAccount
    case deployContract(DeployContractAction)
    case functionCall(FunctionCallAction)
    case transfer(TransferAction)
    case stake(StakeAction)
    case addKey(AddKeyAction)
    case deleteKey(DeleteKeyAction)
    case deleteAccount(DeleteAccountAction)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if dict["CreateAccount"] != nil {
                self = .createAccount
            } else if let deployContract = dict["DeployContract"] {
                self = .deployContract(try deployContract.decode(DeployContractAction.self))
            } else if let functionCall = dict["FunctionCall"] {
                self = .functionCall(try functionCall.decode(FunctionCallAction.self))
            } else if let transfer = dict["Transfer"] {
                self = .transfer(try transfer.decode(TransferAction.self))
            } else if let stake = dict["Stake"] {
                self = .stake(try stake.decode(StakeAction.self))
            } else if let addKey = dict["AddKey"] {
                self = .addKey(try addKey.decode(AddKeyAction.self))
            } else if let deleteKey = dict["DeleteKey"] {
                self = .deleteKey(try deleteKey.decode(DeleteKeyAction.self))
            } else if let deleteAccount = dict["DeleteAccount"] {
                self = .deleteAccount(try deleteAccount.decode(DeleteAccountAction.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid Action")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid Action")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .createAccount:
            try container.encode(["CreateAccount": AnyCodable(())])
        case .deployContract(let action):
            try container.encode(["DeployContract": AnyCodable(action)])
        case .functionCall(let action):
            try container.encode(["FunctionCall": AnyCodable(action)])
        case .transfer(let action):
            try container.encode(["Transfer": AnyCodable(action)])
        case .stake(let action):
            try container.encode(["Stake": AnyCodable(action)])
        case .addKey(let action):
            try container.encode(["AddKey": AnyCodable(action)])
        case .deleteKey(let action):
            try container.encode(["DeleteKey": AnyCodable(action)])
        case .deleteAccount(let action):
            try container.encode(["DeleteAccount": AnyCodable(action)])
        }
    }
}

/// Deploy contract action
public struct DeployContractAction: Codable, Sendable {
    public let code: String // Base64 encoded WASM
    
    public init(code: String) {
        self.code = code
    }
}

/// Function call action
public struct FunctionCallAction: Codable, Sendable {
    public let methodName: String
    public let args: String // Base64 encoded JSON
    public let gas: Gas
    public let deposit: Balance
    
    public init(methodName: String, args: String, gas: Gas, deposit: Balance) {
        self.methodName = methodName
        self.args = args
        self.gas = gas
        self.deposit = deposit
    }
}

/// Transfer action
public struct TransferAction: Codable, Sendable {
    public let deposit: Balance
    
    public init(deposit: Balance) {
        self.deposit = deposit
    }
}

/// Stake action
public struct StakeAction: Codable, Sendable {
    public let stake: Balance
    public let publicKey: PublicKey
    
    public init(stake: Balance, publicKey: PublicKey) {
        self.stake = stake
        self.publicKey = publicKey
    }
}

/// Add key action
public struct AddKeyAction: Codable, Sendable {
    public let publicKey: PublicKey
    public let accessKey: AccessKey
    
    public init(publicKey: PublicKey, accessKey: AccessKey) {
        self.publicKey = publicKey
        self.accessKey = accessKey
    }
}

/// Delete key action
public struct DeleteKeyAction: Codable, Sendable {
    public let publicKey: PublicKey
    
    public init(publicKey: PublicKey) {
        self.publicKey = publicKey
    }
}

/// Delete account action
public struct DeleteAccountAction: Codable, Sendable {
    public let beneficiaryId: AccountId
    
    public init(beneficiaryId: AccountId) {
        self.beneficiaryId = beneficiaryId
    }
}

// MARK: - RPC Request/Response Types

/// RPC query request
public struct RpcQueryRequest: Codable, Sendable {
    public let requestType: String
    public let blockId: BlockId?
    public let finality: Finality?
    public let accountId: AccountId?
    public let prefixBase64: String?
    public let keyBase64: String?
    public let path: String?
    public let data: String?
    public let methodName: String?
    public let args: String?
    
    public init(requestType: String, blockId: BlockId? = nil, finality: Finality? = nil, accountId: AccountId? = nil, prefixBase64: String? = nil, keyBase64: String? = nil, path: String? = nil, data: String? = nil, methodName: String? = nil, args: String? = nil) {
        self.requestType = requestType
        self.blockId = blockId
        self.finality = finality
        self.accountId = accountId
        self.prefixBase64 = prefixBase64
        self.keyBase64 = keyBase64
        self.path = path
        self.data = data
        self.methodName = methodName
        self.args = args
    }
}

/// RPC query response
public struct RpcQueryResponse: Codable, Sendable {
    public let blockHash: BlockHash
    public let blockHeight: BlockHeight
    public let proof: [String]?
    public let value: String?
    public let logs: [String]?
    public let error: String?
    
    public init(blockHash: BlockHash, blockHeight: BlockHeight, proof: [String]? = nil, value: String? = nil, logs: [String]? = nil, error: String? = nil) {
        self.blockHash = blockHash
        self.blockHeight = blockHeight
        self.proof = proof
        self.value = value
        self.logs = logs
        self.error = error
    }
}

// MARK: - Utility Types

/// AnyCodable - allows encoding/decoding of any JSON value
public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode AnyCodable")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let string = value as? String {
            try container.encode(string)
        } else if let int = value as? Int {
            try container.encode(int)
        } else if let double = value as? Double {
            try container.encode(double)
        } else if let bool = value as? Bool {
            try container.encode(bool)
        } else if let array = value as? [Any] {
            try container.encode(array.map { AnyCodable($0) })
        } else if let dict = value as? [String: Any] {
            try container.encode(dict.mapValues { AnyCodable($0) })
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unable to encode AnyCodable"))
        }
    }
}

// MARK: - Extensions for AnyCodable

extension AnyCodable {
    public func decode<T: Codable>(_ type: T.Type) throws -> T {
        let data = try JSONEncoder().encode(self)
        return try JSONDecoder().decode(type, from: data)
    }
}
