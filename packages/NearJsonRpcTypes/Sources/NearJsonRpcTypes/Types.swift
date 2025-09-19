// Auto-generated Swift types from NEAR OpenAPI spec
// Generated on: 2025-09-19
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
    public let cause: AnyCodable?
    public let name: String?
    
    public init(code: Int, message: String, data: AnyCodable? = nil, cause: AnyCodable? = nil, name: String? = nil) {
        self.code = code
        self.message = message
        self.data = data
        self.cause = cause
        self.name = name
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

// MARK: - Generated Types from OpenAPI Schema
/// Access key provides limited access to an account. Each access key belongs to some account and
is identified by a unique (within the account) public key. One account may have large number of
access keys. Access keys allow to act on behalf of the account by restricting transactions
that can be issued.
`account_id,public_key` is a key in the state
public struct AccessKey: Codable, Sendable {
    public let permission: AnyCodable
    public let nonce: UInt64

    public init(permission: AnyCodable, nonce: UInt64) {
        self.permission = permission
        self.nonce = nonce
    }
}

/// Describes the cost of creating an access key.
public struct AccessKeyCreationConfigView: Codable, Sendable {
    public let function_call_cost: AnyCodable
    public let function_call_cost_per_byte: AnyCodable
    public let full_access_cost: AnyCodable

    public init(function_call_cost: AnyCodable, function_call_cost_per_byte: AnyCodable, full_access_cost: AnyCodable) {
        self.function_call_cost = function_call_cost
        self.function_call_cost_per_byte = function_call_cost_per_byte
        self.full_access_cost = full_access_cost
    }
}

/// Describes information about an access key including the public key.
public struct AccessKeyInfoView: Codable, Sendable {
    public let access_key: AccessKeyView
    public let public_key: PublicKey

    public init(access_key: AccessKeyView, public_key: PublicKey) {
        self.access_key = access_key
        self.public_key = public_key
    }
}

/// Lists access keys
public struct AccessKeyList: Codable, Sendable {
    public let keys: [AnyCodable]

    public init(keys: [AnyCodable]) {
        self.keys = keys
    }
}

/// Defines permissions for AccessKey
public enum AccessKeyPermission: Codable, Sendable {
    case FunctionCall(FunctionCallPermission)
    case FullAccess

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let functioncall = dict["FunctionCall"] {
                self = .FunctionCall(try functioncall.decode(FunctionCallPermission.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermission")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "FullAccess": self = .FullAccess
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermission: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermission")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .FunctionCall(let value):
            try container.encode(["FunctionCall": AnyCodable(value)])
        case .FullAccess:
            try container.encode("FullAccess")
        }
    }
}

/// Describes the permission scope for an access key. Whether it is a function call or a full access key.
public enum AccessKeyPermissionView: Codable, Sendable {
    case FullAccess
    case FunctionCall(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let functioncall = dict["FunctionCall"] {
                self = .FunctionCall(try functioncall.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermissionView")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "FullAccess": self = .FullAccess
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermissionView: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AccessKeyPermissionView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .FullAccess:
            try container.encode("FullAccess")
        case .FunctionCall(let value):
            try container.encode(["FunctionCall": AnyCodable(value)])
        }
    }
}

/// Describes access key permission scope and nonce.
public struct AccessKeyView: Codable, Sendable {
    public let nonce: UInt64
    public let permission: AccessKeyPermissionView

    public init(nonce: UInt64, permission: AccessKeyPermissionView) {
        self.nonce = nonce
        self.permission = permission
    }
}

/// The structure describes configuration for creation of new accounts.
public struct AccountCreationConfigView: Codable, Sendable {
    public let min_allowed_top_level_account_length: Int
    public let registrar_account_id: AnyCodable

    public init(min_allowed_top_level_account_length: Int, registrar_account_id: AnyCodable) {
        self.min_allowed_top_level_account_length = min_allowed_top_level_account_length
        self.registrar_account_id = registrar_account_id
    }
}

/// AccountData is a piece of global state that a validator
signs and broadcasts to the network.

It is essentially the data that a validator wants to share with the network.
All the nodes in the network are collecting the account data
broadcasted by the validators.
Since the number of the validators is bounded and their
identity is known (and the maximal size of allowed AccountData is bounded)
the global state that is distributed in the form of AccountData is bounded
as well.
Find more information in the docs [here](https://github.com/near/nearcore/blob/560f7fc8f4b3106e0d5d46050688610b1f104ac6/chain/client/src/client.rs#L2232)
public struct AccountDataView: Codable, Sendable {
    public let peer_id: AnyCodable
    public let proxies: [AnyCodable]
    public let timestamp: String
    public let account_key: AnyCodable

    public init(peer_id: AnyCodable, proxies: [AnyCodable], timestamp: String, account_key: AnyCodable) {
        self.peer_id = peer_id
        self.proxies = proxies
        self.timestamp = timestamp
        self.account_key = account_key
    }
}

/// NEAR Account Identifier.

This is a unique, syntactically valid, human-readable account identifier on the NEAR network.

[See the crate-level docs for information about validation.](index.html#account-id-rules)

Also see [Error kind precedence](AccountId#error-kind-precedence).

## Examples

```
use near_account_id::AccountId;

let alice: AccountId = "alice.near".parse().unwrap();

assert!("ƒelicia.near".parse::<AccountId>().is_err()); // (ƒ is not f)
```
public typealias AccountId = String

public typealias AccountIdValidityRulesVersion = Int

/// Account info for validators
public struct AccountInfo: Codable, Sendable {
    public let account_id: AccountId
    public let amount: String
    public let public_key: PublicKey

    public init(account_id: AccountId, amount: String, public_key: PublicKey) {
        self.account_id = account_id
        self.amount = amount
        self.public_key = public_key
    }
}

/// A view of the account
public struct AccountView: Codable, Sendable {
    public let storage_usage: UInt64
    public let amount: String
    public let code_hash: CryptoHash
    public let storage_paid_at: UInt64?
    public let global_contract_hash: AnyCodable?
    public let locked: String
    public let global_contract_account_id: AnyCodable?

    public init(storage_usage: UInt64, amount: String, code_hash: CryptoHash, storage_paid_at: UInt64? = nil, global_contract_hash: AnyCodable? = nil, locked: String, global_contract_account_id: AnyCodable? = nil) {
        self.storage_usage = storage_usage
        self.amount = amount
        self.code_hash = code_hash
        self.storage_paid_at = storage_paid_at
        self.global_contract_hash = global_contract_hash
        self.locked = locked
        self.global_contract_account_id = global_contract_account_id
    }
}

/// Account ID with its public key.
public struct AccountWithPublicKey: Codable, Sendable {
    public let public_key: PublicKey
    public let account_id: AccountId

    public init(public_key: PublicKey, account_id: AccountId) {
        self.public_key = public_key
        self.account_id = account_id
    }
}

/// Describes the cost of creating a specific action, `Action`. Includes all variants.
public struct ActionCreationConfigView: Codable, Sendable {
    public let create_account_cost: AnyCodable
    public let delete_key_cost: AnyCodable
    public let function_call_cost_per_byte: AnyCodable
    public let transfer_cost: AnyCodable
    public let stake_cost: AnyCodable
    public let add_key_cost: AnyCodable
    public let deploy_contract_cost: AnyCodable
    public let delete_account_cost: AnyCodable
    public let deploy_contract_cost_per_byte: AnyCodable
    public let function_call_cost: AnyCodable
    public let delegate_cost: AnyCodable

    public init(create_account_cost: AnyCodable, delete_key_cost: AnyCodable, function_call_cost_per_byte: AnyCodable, transfer_cost: AnyCodable, stake_cost: AnyCodable, add_key_cost: AnyCodable, deploy_contract_cost: AnyCodable, delete_account_cost: AnyCodable, deploy_contract_cost_per_byte: AnyCodable, function_call_cost: AnyCodable, delegate_cost: AnyCodable) {
        self.create_account_cost = create_account_cost
        self.delete_key_cost = delete_key_cost
        self.function_call_cost_per_byte = function_call_cost_per_byte
        self.transfer_cost = transfer_cost
        self.stake_cost = stake_cost
        self.add_key_cost = add_key_cost
        self.deploy_contract_cost = deploy_contract_cost
        self.delete_account_cost = delete_account_cost
        self.deploy_contract_cost_per_byte = deploy_contract_cost_per_byte
        self.function_call_cost = function_call_cost
        self.delegate_cost = delegate_cost
    }
}

/// An error happened during Action execution
public struct ActionError: Codable, Sendable {
    public let index: UInt64?
    public let kind: AnyCodable

    public init(index: UInt64? = nil, kind: AnyCodable) {
        self.index = index
        self.kind = kind
    }
}

public enum ActionErrorKind: Codable, Sendable {
    case AccountAlreadyExists(AnyCodable)
    case AccountDoesNotExist(AnyCodable)
    case CreateAccountOnlyByRegistrar(AnyCodable)
    case CreateAccountNotAllowed(AnyCodable)
    case ActorNoPermission(AnyCodable)
    case DeleteKeyDoesNotExist(AnyCodable)
    case AddKeyAlreadyExists(AnyCodable)
    case DeleteAccountStaking(AnyCodable)
    case LackBalanceForState(AnyCodable)
    case TriesToUnstake(AnyCodable)
    case TriesToStake(AnyCodable)
    case InsufficientStake(AnyCodable)
    case FunctionCallError(FunctionCallError)
    case NewReceiptValidationError(ReceiptValidationError)
    case OnlyImplicitAccountCreationAllowed(AnyCodable)
    case DeleteAccountWithLargeState(AnyCodable)
    case DelegateActionInvalidSignature
    case DelegateActionSenderDoesNotMatchTxReceiver(AnyCodable)
    case DelegateActionExpired
    case DelegateActionAccessKeyError(InvalidAccessKeyError)
    case DelegateActionInvalidNonce(AnyCodable)
    case DelegateActionNonceTooLarge(AnyCodable)
    case GlobalContractDoesNotExist(AnyCodable)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let accountalreadyexists = dict["AccountAlreadyExists"] {
                self = .AccountAlreadyExists(try accountalreadyexists.decode(AnyCodable.self))
            } else             if let accountdoesnotexist = dict["AccountDoesNotExist"] {
                self = .AccountDoesNotExist(try accountdoesnotexist.decode(AnyCodable.self))
            } else             if let createaccountonlybyregistrar = dict["CreateAccountOnlyByRegistrar"] {
                self = .CreateAccountOnlyByRegistrar(try createaccountonlybyregistrar.decode(AnyCodable.self))
            } else             if let createaccountnotallowed = dict["CreateAccountNotAllowed"] {
                self = .CreateAccountNotAllowed(try createaccountnotallowed.decode(AnyCodable.self))
            } else             if let actornopermission = dict["ActorNoPermission"] {
                self = .ActorNoPermission(try actornopermission.decode(AnyCodable.self))
            } else             if let deletekeydoesnotexist = dict["DeleteKeyDoesNotExist"] {
                self = .DeleteKeyDoesNotExist(try deletekeydoesnotexist.decode(AnyCodable.self))
            } else             if let addkeyalreadyexists = dict["AddKeyAlreadyExists"] {
                self = .AddKeyAlreadyExists(try addkeyalreadyexists.decode(AnyCodable.self))
            } else             if let deleteaccountstaking = dict["DeleteAccountStaking"] {
                self = .DeleteAccountStaking(try deleteaccountstaking.decode(AnyCodable.self))
            } else             if let lackbalanceforstate = dict["LackBalanceForState"] {
                self = .LackBalanceForState(try lackbalanceforstate.decode(AnyCodable.self))
            } else             if let triestounstake = dict["TriesToUnstake"] {
                self = .TriesToUnstake(try triestounstake.decode(AnyCodable.self))
            } else             if let triestostake = dict["TriesToStake"] {
                self = .TriesToStake(try triestostake.decode(AnyCodable.self))
            } else             if let insufficientstake = dict["InsufficientStake"] {
                self = .InsufficientStake(try insufficientstake.decode(AnyCodable.self))
            } else             if let functioncallerror = dict["FunctionCallError"] {
                self = .FunctionCallError(try functioncallerror.decode(FunctionCallError.self))
            } else             if let newreceiptvalidationerror = dict["NewReceiptValidationError"] {
                self = .NewReceiptValidationError(try newreceiptvalidationerror.decode(ReceiptValidationError.self))
            } else             if let onlyimplicitaccountcreationallowed = dict["OnlyImplicitAccountCreationAllowed"] {
                self = .OnlyImplicitAccountCreationAllowed(try onlyimplicitaccountcreationallowed.decode(AnyCodable.self))
            } else             if let deleteaccountwithlargestate = dict["DeleteAccountWithLargeState"] {
                self = .DeleteAccountWithLargeState(try deleteaccountwithlargestate.decode(AnyCodable.self))
            } else             if let delegateactionsenderdoesnotmatchtxreceiver = dict["DelegateActionSenderDoesNotMatchTxReceiver"] {
                self = .DelegateActionSenderDoesNotMatchTxReceiver(try delegateactionsenderdoesnotmatchtxreceiver.decode(AnyCodable.self))
            } else             if let delegateactionaccesskeyerror = dict["DelegateActionAccessKeyError"] {
                self = .DelegateActionAccessKeyError(try delegateactionaccesskeyerror.decode(InvalidAccessKeyError.self))
            } else             if let delegateactioninvalidnonce = dict["DelegateActionInvalidNonce"] {
                self = .DelegateActionInvalidNonce(try delegateactioninvalidnonce.decode(AnyCodable.self))
            } else             if let delegateactionnoncetoolarge = dict["DelegateActionNonceTooLarge"] {
                self = .DelegateActionNonceTooLarge(try delegateactionnoncetoolarge.decode(AnyCodable.self))
            } else             if let globalcontractdoesnotexist = dict["GlobalContractDoesNotExist"] {
                self = .GlobalContractDoesNotExist(try globalcontractdoesnotexist.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionErrorKind")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "DelegateActionInvalidSignature": self = .DelegateActionInvalidSignature
            case "DelegateActionExpired": self = .DelegateActionExpired
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionErrorKind: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionErrorKind")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .AccountAlreadyExists(let value):
            try container.encode(["AccountAlreadyExists": AnyCodable(value)])
        case .AccountDoesNotExist(let value):
            try container.encode(["AccountDoesNotExist": AnyCodable(value)])
        case .CreateAccountOnlyByRegistrar(let value):
            try container.encode(["CreateAccountOnlyByRegistrar": AnyCodable(value)])
        case .CreateAccountNotAllowed(let value):
            try container.encode(["CreateAccountNotAllowed": AnyCodable(value)])
        case .ActorNoPermission(let value):
            try container.encode(["ActorNoPermission": AnyCodable(value)])
        case .DeleteKeyDoesNotExist(let value):
            try container.encode(["DeleteKeyDoesNotExist": AnyCodable(value)])
        case .AddKeyAlreadyExists(let value):
            try container.encode(["AddKeyAlreadyExists": AnyCodable(value)])
        case .DeleteAccountStaking(let value):
            try container.encode(["DeleteAccountStaking": AnyCodable(value)])
        case .LackBalanceForState(let value):
            try container.encode(["LackBalanceForState": AnyCodable(value)])
        case .TriesToUnstake(let value):
            try container.encode(["TriesToUnstake": AnyCodable(value)])
        case .TriesToStake(let value):
            try container.encode(["TriesToStake": AnyCodable(value)])
        case .InsufficientStake(let value):
            try container.encode(["InsufficientStake": AnyCodable(value)])
        case .FunctionCallError(let value):
            try container.encode(["FunctionCallError": AnyCodable(value)])
        case .NewReceiptValidationError(let value):
            try container.encode(["NewReceiptValidationError": AnyCodable(value)])
        case .OnlyImplicitAccountCreationAllowed(let value):
            try container.encode(["OnlyImplicitAccountCreationAllowed": AnyCodable(value)])
        case .DeleteAccountWithLargeState(let value):
            try container.encode(["DeleteAccountWithLargeState": AnyCodable(value)])
        case .DelegateActionInvalidSignature:
            try container.encode("DelegateActionInvalidSignature")
        case .DelegateActionSenderDoesNotMatchTxReceiver(let value):
            try container.encode(["DelegateActionSenderDoesNotMatchTxReceiver": AnyCodable(value)])
        case .DelegateActionExpired:
            try container.encode("DelegateActionExpired")
        case .DelegateActionAccessKeyError(let value):
            try container.encode(["DelegateActionAccessKeyError": AnyCodable(value)])
        case .DelegateActionInvalidNonce(let value):
            try container.encode(["DelegateActionInvalidNonce": AnyCodable(value)])
        case .DelegateActionNonceTooLarge(let value):
            try container.encode(["DelegateActionNonceTooLarge": AnyCodable(value)])
        case .GlobalContractDoesNotExist(let value):
            try container.encode(["GlobalContractDoesNotExist": AnyCodable(value)])
        }
    }
}

public enum ActionView: Codable, Sendable {
    case CreateAccount
    case DeployContract(AnyCodable)
    case FunctionCall(AnyCodable)
    case Transfer(AnyCodable)
    case Stake(AnyCodable)
    case AddKey(AnyCodable)
    case DeleteKey(AnyCodable)
    case DeleteAccount(AnyCodable)
    case Delegate(AnyCodable)
    case DeployGlobalContract(AnyCodable)
    case DeployGlobalContractByAccountId(AnyCodable)
    case UseGlobalContract(AnyCodable)
    case UseGlobalContractByAccountId(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let deploycontract = dict["DeployContract"] {
                self = .DeployContract(try deploycontract.decode(AnyCodable.self))
            } else             if let functioncall = dict["FunctionCall"] {
                self = .FunctionCall(try functioncall.decode(AnyCodable.self))
            } else             if let transfer = dict["Transfer"] {
                self = .Transfer(try transfer.decode(AnyCodable.self))
            } else             if let stake = dict["Stake"] {
                self = .Stake(try stake.decode(AnyCodable.self))
            } else             if let addkey = dict["AddKey"] {
                self = .AddKey(try addkey.decode(AnyCodable.self))
            } else             if let deletekey = dict["DeleteKey"] {
                self = .DeleteKey(try deletekey.decode(AnyCodable.self))
            } else             if let deleteaccount = dict["DeleteAccount"] {
                self = .DeleteAccount(try deleteaccount.decode(AnyCodable.self))
            } else             if let delegate = dict["Delegate"] {
                self = .Delegate(try delegate.decode(AnyCodable.self))
            } else             if let deployglobalcontract = dict["DeployGlobalContract"] {
                self = .DeployGlobalContract(try deployglobalcontract.decode(AnyCodable.self))
            } else             if let deployglobalcontractbyaccountid = dict["DeployGlobalContractByAccountId"] {
                self = .DeployGlobalContractByAccountId(try deployglobalcontractbyaccountid.decode(AnyCodable.self))
            } else             if let useglobalcontract = dict["UseGlobalContract"] {
                self = .UseGlobalContract(try useglobalcontract.decode(AnyCodable.self))
            } else             if let useglobalcontractbyaccountid = dict["UseGlobalContractByAccountId"] {
                self = .UseGlobalContractByAccountId(try useglobalcontractbyaccountid.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionView")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "CreateAccount": self = .CreateAccount
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionView: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .CreateAccount:
            try container.encode("CreateAccount")
        case .DeployContract(let value):
            try container.encode(["DeployContract": AnyCodable(value)])
        case .FunctionCall(let value):
            try container.encode(["FunctionCall": AnyCodable(value)])
        case .Transfer(let value):
            try container.encode(["Transfer": AnyCodable(value)])
        case .Stake(let value):
            try container.encode(["Stake": AnyCodable(value)])
        case .AddKey(let value):
            try container.encode(["AddKey": AnyCodable(value)])
        case .DeleteKey(let value):
            try container.encode(["DeleteKey": AnyCodable(value)])
        case .DeleteAccount(let value):
            try container.encode(["DeleteAccount": AnyCodable(value)])
        case .Delegate(let value):
            try container.encode(["Delegate": AnyCodable(value)])
        case .DeployGlobalContract(let value):
            try container.encode(["DeployGlobalContract": AnyCodable(value)])
        case .DeployGlobalContractByAccountId(let value):
            try container.encode(["DeployGlobalContractByAccountId": AnyCodable(value)])
        case .UseGlobalContract(let value):
            try container.encode(["UseGlobalContract": AnyCodable(value)])
        case .UseGlobalContractByAccountId(let value):
            try container.encode(["UseGlobalContractByAccountId": AnyCodable(value)])
        }
    }
}

/// Describes the error for validating a list of actions.
public enum ActionsValidationError: Codable, Sendable {
    case DeleteActionMustBeFinal
    case TotalPrepaidGasExceeded(AnyCodable)
    case TotalNumberOfActionsExceeded(AnyCodable)
    case AddKeyMethodNamesNumberOfBytesExceeded(AnyCodable)
    case AddKeyMethodNameLengthExceeded(AnyCodable)
    case IntegerOverflow
    case InvalidAccountId(AnyCodable)
    case ContractSizeExceeded(AnyCodable)
    case FunctionCallMethodNameLengthExceeded(AnyCodable)
    case FunctionCallArgumentsLengthExceeded(AnyCodable)
    case UnsuitableStakingKey(AnyCodable)
    case FunctionCallZeroAttachedGas
    case DelegateActionMustBeOnlyOne
    case UnsupportedProtocolFeature(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let totalprepaidgasexceeded = dict["TotalPrepaidGasExceeded"] {
                self = .TotalPrepaidGasExceeded(try totalprepaidgasexceeded.decode(AnyCodable.self))
            } else             if let totalnumberofactionsexceeded = dict["TotalNumberOfActionsExceeded"] {
                self = .TotalNumberOfActionsExceeded(try totalnumberofactionsexceeded.decode(AnyCodable.self))
            } else             if let addkeymethodnamesnumberofbytesexceeded = dict["AddKeyMethodNamesNumberOfBytesExceeded"] {
                self = .AddKeyMethodNamesNumberOfBytesExceeded(try addkeymethodnamesnumberofbytesexceeded.decode(AnyCodable.self))
            } else             if let addkeymethodnamelengthexceeded = dict["AddKeyMethodNameLengthExceeded"] {
                self = .AddKeyMethodNameLengthExceeded(try addkeymethodnamelengthexceeded.decode(AnyCodable.self))
            } else             if let invalidaccountid = dict["InvalidAccountId"] {
                self = .InvalidAccountId(try invalidaccountid.decode(AnyCodable.self))
            } else             if let contractsizeexceeded = dict["ContractSizeExceeded"] {
                self = .ContractSizeExceeded(try contractsizeexceeded.decode(AnyCodable.self))
            } else             if let functioncallmethodnamelengthexceeded = dict["FunctionCallMethodNameLengthExceeded"] {
                self = .FunctionCallMethodNameLengthExceeded(try functioncallmethodnamelengthexceeded.decode(AnyCodable.self))
            } else             if let functioncallargumentslengthexceeded = dict["FunctionCallArgumentsLengthExceeded"] {
                self = .FunctionCallArgumentsLengthExceeded(try functioncallargumentslengthexceeded.decode(AnyCodable.self))
            } else             if let unsuitablestakingkey = dict["UnsuitableStakingKey"] {
                self = .UnsuitableStakingKey(try unsuitablestakingkey.decode(AnyCodable.self))
            } else             if let unsupportedprotocolfeature = dict["UnsupportedProtocolFeature"] {
                self = .UnsupportedProtocolFeature(try unsupportedprotocolfeature.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionsValidationError")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "DeleteActionMustBeFinal": self = .DeleteActionMustBeFinal
            case "IntegerOverflow": self = .IntegerOverflow
            case "FunctionCallZeroAttachedGas": self = .FunctionCallZeroAttachedGas
            case "DelegateActionMustBeOnlyOne": self = .DelegateActionMustBeOnlyOne
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionsValidationError: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ActionsValidationError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .DeleteActionMustBeFinal:
            try container.encode("DeleteActionMustBeFinal")
        case .TotalPrepaidGasExceeded(let value):
            try container.encode(["TotalPrepaidGasExceeded": AnyCodable(value)])
        case .TotalNumberOfActionsExceeded(let value):
            try container.encode(["TotalNumberOfActionsExceeded": AnyCodable(value)])
        case .AddKeyMethodNamesNumberOfBytesExceeded(let value):
            try container.encode(["AddKeyMethodNamesNumberOfBytesExceeded": AnyCodable(value)])
        case .AddKeyMethodNameLengthExceeded(let value):
            try container.encode(["AddKeyMethodNameLengthExceeded": AnyCodable(value)])
        case .IntegerOverflow:
            try container.encode("IntegerOverflow")
        case .InvalidAccountId(let value):
            try container.encode(["InvalidAccountId": AnyCodable(value)])
        case .ContractSizeExceeded(let value):
            try container.encode(["ContractSizeExceeded": AnyCodable(value)])
        case .FunctionCallMethodNameLengthExceeded(let value):
            try container.encode(["FunctionCallMethodNameLengthExceeded": AnyCodable(value)])
        case .FunctionCallArgumentsLengthExceeded(let value):
            try container.encode(["FunctionCallArgumentsLengthExceeded": AnyCodable(value)])
        case .UnsuitableStakingKey(let value):
            try container.encode(["UnsuitableStakingKey": AnyCodable(value)])
        case .FunctionCallZeroAttachedGas:
            try container.encode("FunctionCallZeroAttachedGas")
        case .DelegateActionMustBeOnlyOne:
            try container.encode("DelegateActionMustBeOnlyOne")
        case .UnsupportedProtocolFeature(let value):
            try container.encode(["UnsupportedProtocolFeature": AnyCodable(value)])
        }
    }
}

/// An action that adds key with public key associated
public struct AddKeyAction: Codable, Sendable {
    public let public_key: AnyCodable
    public let access_key: AnyCodable

    public init(public_key: AnyCodable, access_key: AnyCodable) {
        self.public_key = public_key
        self.access_key = access_key
    }
}

/// `BandwidthRequest` describes the size of receipts that a shard would like to send to another shard.
When a shard wants to send a lot of receipts to another shard, it needs to create a request and wait
for a bandwidth grant from the bandwidth scheduler.
public struct BandwidthRequest: Codable, Sendable {
    public let to_shard: Int
    public let requested_values_bitmap: AnyCodable

    public init(to_shard: Int, requested_values_bitmap: AnyCodable) {
        self.to_shard = to_shard
        self.requested_values_bitmap = requested_values_bitmap
    }
}

/// Bitmap which describes which values from the predefined list are being requested.
The nth bit is set to 1 when the nth value from the list is being requested.
public struct BandwidthRequestBitmap: Codable, Sendable {
    public let data: [Int]

    public init(data: [Int]) {
        self.data = data
    }
}

/// A list of shard's bandwidth requests.
Describes how much the shard would like to send to other shards.
public enum BandwidthRequests: Codable, Sendable {
    case V1(BandwidthRequestsV1)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let v1 = dict["V1"] {
                self = .V1(try v1.decode(BandwidthRequestsV1.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid BandwidthRequests")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid BandwidthRequests")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .V1(let value):
            try container.encode(["V1": AnyCodable(value)])
        }
    }
}

/// Version 1 of [`BandwidthRequest`].
public struct BandwidthRequestsV1: Codable, Sendable {
    public let requests: [AnyCodable]

    public init(requests: [AnyCodable]) {
        self.requests = requests
    }
}

/// A part of a state for the current head of a light client. More info [here](https://nomicon.io/ChainSpec/LightClient).
public struct BlockHeaderInnerLiteView: Codable, Sendable {
    public let outcome_root: CryptoHash
    public let epoch_id: AnyCodable
    public let next_epoch_id: AnyCodable
    public let height: UInt64
    public let next_bp_hash: AnyCodable
    public let block_merkle_root: AnyCodable
    public let timestamp_nanosec: String
    public let prev_state_root: CryptoHash
    public let timestamp: UInt64

    public init(outcome_root: CryptoHash, epoch_id: AnyCodable, next_epoch_id: AnyCodable, height: UInt64, next_bp_hash: AnyCodable, block_merkle_root: AnyCodable, timestamp_nanosec: String, prev_state_root: CryptoHash, timestamp: UInt64) {
        self.outcome_root = outcome_root
        self.epoch_id = epoch_id
        self.next_epoch_id = next_epoch_id
        self.height = height
        self.next_bp_hash = next_bp_hash
        self.block_merkle_root = block_merkle_root
        self.timestamp_nanosec = timestamp_nanosec
        self.prev_state_root = prev_state_root
        self.timestamp = timestamp
    }
}

/// Contains main info about the block.
public struct BlockHeaderView: Codable, Sendable {
    public let rent_paid: String
    public let timestamp: UInt64
    public let block_body_hash: AnyCodable?
    public let timestamp_nanosec: String
    public let challenges_root: CryptoHash
    public let prev_height: UInt64?
    public let challenges_result: [AnyCodable]
    public let outcome_root: CryptoHash
    public let signature: AnyCodable
    public let latest_protocol_version: Int
    public let chunks_included: UInt64
    public let chunk_receipts_root: CryptoHash
    public let height: UInt64
    public let validator_proposals: [AnyCodable]
    public let approvals: [AnyCodable]
    public let last_ds_final_block: CryptoHash
    public let chunk_headers_root: CryptoHash
    public let chunk_endorsements: [[Int]]?
    public let prev_state_root: CryptoHash
    public let block_ordinal: UInt64?
    public let chunk_tx_root: CryptoHash
    public let prev_hash: AnyCodable
    public let epoch_id: CryptoHash
    public let hash: CryptoHash
    public let block_merkle_root: CryptoHash
    public let next_bp_hash: CryptoHash
    public let validator_reward: String
    public let chunk_mask: [Bool]
    public let total_supply: String
    public let random_value: CryptoHash
    public let epoch_sync_data_hash: AnyCodable?
    public let last_final_block: CryptoHash
    public let next_epoch_id: CryptoHash
    public let gas_price: String

    public init(rent_paid: String, timestamp: UInt64, block_body_hash: AnyCodable? = nil, timestamp_nanosec: String, challenges_root: CryptoHash, prev_height: UInt64? = nil, challenges_result: [AnyCodable], outcome_root: CryptoHash, signature: AnyCodable, latest_protocol_version: Int, chunks_included: UInt64, chunk_receipts_root: CryptoHash, height: UInt64, validator_proposals: [AnyCodable], approvals: [AnyCodable], last_ds_final_block: CryptoHash, chunk_headers_root: CryptoHash, chunk_endorsements: [[Int]]? = nil, prev_state_root: CryptoHash, block_ordinal: UInt64? = nil, chunk_tx_root: CryptoHash, prev_hash: AnyCodable, epoch_id: CryptoHash, hash: CryptoHash, block_merkle_root: CryptoHash, next_bp_hash: CryptoHash, validator_reward: String, chunk_mask: [Bool], total_supply: String, random_value: CryptoHash, epoch_sync_data_hash: AnyCodable? = nil, last_final_block: CryptoHash, next_epoch_id: CryptoHash, gas_price: String) {
        self.rent_paid = rent_paid
        self.timestamp = timestamp
        self.block_body_hash = block_body_hash
        self.timestamp_nanosec = timestamp_nanosec
        self.challenges_root = challenges_root
        self.prev_height = prev_height
        self.challenges_result = challenges_result
        self.outcome_root = outcome_root
        self.signature = signature
        self.latest_protocol_version = latest_protocol_version
        self.chunks_included = chunks_included
        self.chunk_receipts_root = chunk_receipts_root
        self.height = height
        self.validator_proposals = validator_proposals
        self.approvals = approvals
        self.last_ds_final_block = last_ds_final_block
        self.chunk_headers_root = chunk_headers_root
        self.chunk_endorsements = chunk_endorsements
        self.prev_state_root = prev_state_root
        self.block_ordinal = block_ordinal
        self.chunk_tx_root = chunk_tx_root
        self.prev_hash = prev_hash
        self.epoch_id = epoch_id
        self.hash = hash
        self.block_merkle_root = block_merkle_root
        self.next_bp_hash = next_bp_hash
        self.validator_reward = validator_reward
        self.chunk_mask = chunk_mask
        self.total_supply = total_supply
        self.random_value = random_value
        self.epoch_sync_data_hash = epoch_sync_data_hash
        self.last_final_block = last_final_block
        self.next_epoch_id = next_epoch_id
        self.gas_price = gas_price
    }
}

public typealias BlockId = AnyCodable

/// Height and hash of a block
public struct BlockStatusView: Codable, Sendable {
    public let hash: CryptoHash
    public let height: UInt64

    public init(hash: CryptoHash, height: UInt64) {
        self.hash = hash
        self.height = height
    }
}

/// A result returned by contract method
public struct CallResult: Codable, Sendable {
    public let logs: [String]
    public let result: [Int]

    public init(logs: [String], result: [Int]) {
        self.logs = logs
        self.result = result
    }
}

/// Status of the [catchup](https://near.github.io/nearcore/architecture/how/sync.html#catchup) process
public struct CatchupStatusView: Codable, Sendable {
    public let sync_block_hash: CryptoHash
    public let blocks_to_catchup: [AnyCodable]
    public let sync_block_height: UInt64
    public let shard_sync_status: AnyCodable

    public init(sync_block_hash: CryptoHash, blocks_to_catchup: [AnyCodable], sync_block_height: UInt64, shard_sync_status: AnyCodable) {
        self.sync_block_hash = sync_block_hash
        self.blocks_to_catchup = blocks_to_catchup
        self.sync_block_height = sync_block_height
        self.shard_sync_status = shard_sync_status
    }
}

/// Config for the Chunk Distribution Network feature.
This allows nodes to push and pull chunks from a central stream.
The two benefits of this approach are: (1) less request/response traffic
on the peer-to-peer network and (2) lower latency for RPC nodes indexing the chain.
public struct ChunkDistributionNetworkConfig: Codable, Sendable {
    public let uris: ChunkDistributionUris
    public let enabled: Bool

    public init(uris: ChunkDistributionUris, enabled: Bool) {
        self.uris = uris
        self.enabled = enabled
    }
}

/// URIs for the Chunk Distribution Network feature.
public struct ChunkDistributionUris: Codable, Sendable {
    public let set: String
    public let get: String

    public init(set: String, get: String) {
        self.set = set
        self.get = get
    }
}

/// Contains main info about the chunk.
public struct ChunkHeaderView: Codable, Sendable {
    public let gas_limit: NearGas
    public let encoded_merkle_root: CryptoHash
    public let signature: Signature
    public let encoded_length: UInt64
    public let chunk_hash: CryptoHash
    public let height_included: UInt64
    public let congestion_info: AnyCodable?
    public let prev_block_hash: CryptoHash
    public let outcome_root: CryptoHash
    public let tx_root: CryptoHash
    public let balance_burnt: String
    public let validator_reward: String
    public let gas_used: NearGas
    public let height_created: UInt64
    public let prev_state_root: CryptoHash
    public let validator_proposals: [AnyCodable]
    public let shard_id: ShardId
    public let rent_paid: String
    public let outgoing_receipts_root: CryptoHash
    public let bandwidth_requests: AnyCodable?

    public init(gas_limit: NearGas, encoded_merkle_root: CryptoHash, signature: Signature, encoded_length: UInt64, chunk_hash: CryptoHash, height_included: UInt64, congestion_info: AnyCodable? = nil, prev_block_hash: CryptoHash, outcome_root: CryptoHash, tx_root: CryptoHash, balance_burnt: String, validator_reward: String, gas_used: NearGas, height_created: UInt64, prev_state_root: CryptoHash, validator_proposals: [AnyCodable], shard_id: ShardId, rent_paid: String, outgoing_receipts_root: CryptoHash, bandwidth_requests: AnyCodable? = nil) {
        self.gas_limit = gas_limit
        self.encoded_merkle_root = encoded_merkle_root
        self.signature = signature
        self.encoded_length = encoded_length
        self.chunk_hash = chunk_hash
        self.height_included = height_included
        self.congestion_info = congestion_info
        self.prev_block_hash = prev_block_hash
        self.outcome_root = outcome_root
        self.tx_root = tx_root
        self.balance_burnt = balance_burnt
        self.validator_reward = validator_reward
        self.gas_used = gas_used
        self.height_created = height_created
        self.prev_state_root = prev_state_root
        self.validator_proposals = validator_proposals
        self.shard_id = shard_id
        self.rent_paid = rent_paid
        self.outgoing_receipts_root = outgoing_receipts_root
        self.bandwidth_requests = bandwidth_requests
    }
}

/// Configuration for a cloud-based archival reader.
public struct CloudArchivalReaderConfig: Codable, Sendable {
    public let cloud_storage: AnyCodable

    public init(cloud_storage: AnyCodable) {
        self.cloud_storage = cloud_storage
    }
}

/// Configuration for a cloud-based archival writer. If this config is present, the writer is enabled and
writes chunk-related data based on the tracked shards. This config also controls additional archival
behavior such as block data and polling interval.
public struct CloudArchivalWriterConfig: Codable, Sendable {
    public let archive_block_data: Bool?
    public let polling_interval: AnyCodable?
    public let cloud_storage: AnyCodable

    public init(archive_block_data: Bool? = nil, polling_interval: AnyCodable? = nil, cloud_storage: AnyCodable) {
        self.archive_block_data = archive_block_data
        self.polling_interval = polling_interval
        self.cloud_storage = cloud_storage
    }
}

/// Configures the external storage used by the archival node.
public struct CloudStorageConfig: Codable, Sendable {
    public let storage: AnyCodable
    public let credentials_file: String?

    public init(storage: AnyCodable, credentials_file: String? = nil) {
        self.storage = storage
        self.credentials_file = credentials_file
    }
}

public enum CompilationError: Codable, Sendable {
    case CodeDoesNotExist(AnyCodable)
    case PrepareError(PrepareError)
    case WasmerCompileError(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let codedoesnotexist = dict["CodeDoesNotExist"] {
                self = .CodeDoesNotExist(try codedoesnotexist.decode(AnyCodable.self))
            } else             if let prepareerror = dict["PrepareError"] {
                self = .PrepareError(try prepareerror.decode(PrepareError.self))
            } else             if let wasmercompileerror = dict["WasmerCompileError"] {
                self = .WasmerCompileError(try wasmercompileerror.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid CompilationError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid CompilationError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .CodeDoesNotExist(let value):
            try container.encode(["CodeDoesNotExist": AnyCodable(value)])
        case .PrepareError(let value):
            try container.encode(["PrepareError": AnyCodable(value)])
        case .WasmerCompileError(let value):
            try container.encode(["WasmerCompileError": AnyCodable(value)])
        }
    }
}

/// The configuration for congestion control. More info about congestion [here](https://near.github.io/nearcore/architecture/how/receipt-congestion.html?highlight=congestion#receipt-congestion)
public struct CongestionControlConfigView: Codable, Sendable {
    public let min_tx_gas: AnyCodable
    public let max_congestion_outgoing_gas: AnyCodable
    public let max_outgoing_gas: AnyCodable
    public let max_congestion_incoming_gas: AnyCodable
    public let outgoing_receipts_usual_size_limit: UInt64
    public let max_congestion_missed_chunks: UInt64
    public let max_tx_gas: AnyCodable
    public let min_outgoing_gas: AnyCodable
    public let reject_tx_congestion_threshold: AnyCodable
    public let max_congestion_memory_consumption: UInt64
    public let allowed_shard_outgoing_gas: AnyCodable
    public let outgoing_receipts_big_size_limit: UInt64

    public init(min_tx_gas: AnyCodable, max_congestion_outgoing_gas: AnyCodable, max_outgoing_gas: AnyCodable, max_congestion_incoming_gas: AnyCodable, outgoing_receipts_usual_size_limit: UInt64, max_congestion_missed_chunks: UInt64, max_tx_gas: AnyCodable, min_outgoing_gas: AnyCodable, reject_tx_congestion_threshold: AnyCodable, max_congestion_memory_consumption: UInt64, allowed_shard_outgoing_gas: AnyCodable, outgoing_receipts_big_size_limit: UInt64) {
        self.min_tx_gas = min_tx_gas
        self.max_congestion_outgoing_gas = max_congestion_outgoing_gas
        self.max_outgoing_gas = max_outgoing_gas
        self.max_congestion_incoming_gas = max_congestion_incoming_gas
        self.outgoing_receipts_usual_size_limit = outgoing_receipts_usual_size_limit
        self.max_congestion_missed_chunks = max_congestion_missed_chunks
        self.max_tx_gas = max_tx_gas
        self.min_outgoing_gas = min_outgoing_gas
        self.reject_tx_congestion_threshold = reject_tx_congestion_threshold
        self.max_congestion_memory_consumption = max_congestion_memory_consumption
        self.allowed_shard_outgoing_gas = allowed_shard_outgoing_gas
        self.outgoing_receipts_big_size_limit = outgoing_receipts_big_size_limit
    }
}

/// Stores the congestion level of a shard. More info about congestion [here](https://near.github.io/nearcore/architecture/how/receipt-congestion.html?highlight=congestion#receipt-congestion)
public struct CongestionInfoView: Codable, Sendable {
    public let delayed_receipts_gas: String
    public let buffered_receipts_gas: String
    public let receipt_bytes: UInt64
    public let allowed_shard: Int

    public init(delayed_receipts_gas: String, buffered_receipts_gas: String, receipt_bytes: UInt64, allowed_shard: Int) {
        self.delayed_receipts_gas = delayed_receipts_gas
        self.buffered_receipts_gas = buffered_receipts_gas
        self.receipt_bytes = receipt_bytes
        self.allowed_shard = allowed_shard
    }
}

/// A view of the contract code.
public struct ContractCodeView: Codable, Sendable {
    public let code_base64: String
    public let hash: CryptoHash

    public init(code_base64: String, hash: CryptoHash) {
        self.code_base64 = code_base64
        self.hash = hash
    }
}

/// Shows gas profile. More info [here](https://near.github.io/nearcore/architecture/gas/gas_profile.html?highlight=WASM_HOST_COST#example-transaction-gas-profile).
public struct CostGasUsed: Codable, Sendable {
    public let cost_category: String
    public let gas_used: String
    public let cost: String

    public init(cost_category: String, gas_used: String, cost: String) {
        self.cost_category = cost_category
        self.gas_used = gas_used
        self.cost = cost
    }
}

/// Create account action
public typealias CreateAccountAction = AnyCodable

public typealias CryptoHash = String

/// Describes information about the current epoch validator
public struct CurrentEpochValidatorInfo: Codable, Sendable {
    public let is_slashed: Bool
    public let num_expected_chunks: UInt64?
    public let num_produced_endorsements_per_shard: [UInt64]?
    public let num_expected_blocks: UInt64
    public let shards: [AnyCodable]
    public let num_expected_endorsements: UInt64?
    public let num_produced_chunks: UInt64?
    public let num_produced_endorsements: UInt64?
    public let shards_endorsed: [AnyCodable]?
    public let num_produced_blocks: UInt64
    public let stake: String
    public let num_produced_chunks_per_shard: [UInt64]?
    public let num_expected_endorsements_per_shard: [UInt64]?
    public let account_id: AccountId
    public let public_key: PublicKey
    public let num_expected_chunks_per_shard: [UInt64]?

    public init(is_slashed: Bool, num_expected_chunks: UInt64? = nil, num_produced_endorsements_per_shard: [UInt64]? = nil, num_expected_blocks: UInt64, shards: [AnyCodable], num_expected_endorsements: UInt64? = nil, num_produced_chunks: UInt64? = nil, num_produced_endorsements: UInt64? = nil, shards_endorsed: [AnyCodable]? = nil, num_produced_blocks: UInt64, stake: String, num_produced_chunks_per_shard: [UInt64]? = nil, num_expected_endorsements_per_shard: [UInt64]? = nil, account_id: AccountId, public_key: PublicKey, num_expected_chunks_per_shard: [UInt64]? = nil) {
        self.is_slashed = is_slashed
        self.num_expected_chunks = num_expected_chunks
        self.num_produced_endorsements_per_shard = num_produced_endorsements_per_shard
        self.num_expected_blocks = num_expected_blocks
        self.shards = shards
        self.num_expected_endorsements = num_expected_endorsements
        self.num_produced_chunks = num_produced_chunks
        self.num_produced_endorsements = num_produced_endorsements
        self.shards_endorsed = shards_endorsed
        self.num_produced_blocks = num_produced_blocks
        self.stake = stake
        self.num_produced_chunks_per_shard = num_produced_chunks_per_shard
        self.num_expected_endorsements_per_shard = num_expected_endorsements_per_shard
        self.account_id = account_id
        self.public_key = public_key
        self.num_expected_chunks_per_shard = num_expected_chunks_per_shard
    }
}

/// The fees settings for a data receipt creation
public struct DataReceiptCreationConfigView: Codable, Sendable {
    public let cost_per_byte: AnyCodable
    public let base_cost: AnyCodable

    public init(cost_per_byte: AnyCodable, base_cost: AnyCodable) {
        self.cost_per_byte = cost_per_byte
        self.base_cost = base_cost
    }
}

public struct DataReceiverView: Codable, Sendable {
    public let receiver_id: AccountId
    public let data_id: CryptoHash

    public init(receiver_id: AccountId, data_id: CryptoHash) {
        self.receiver_id = receiver_id
        self.data_id = data_id
    }
}

/// This action allows to execute the inner actions behalf of the defined sender.
public struct DelegateAction: Codable, Sendable {
    public let nonce: UInt64
    public let receiver_id: AnyCodable
    public let max_block_height: UInt64
    public let sender_id: AnyCodable
    public let actions: [AnyCodable]
    public let public_key: AnyCodable

    public init(nonce: UInt64, receiver_id: AnyCodable, max_block_height: UInt64, sender_id: AnyCodable, actions: [AnyCodable], public_key: AnyCodable) {
        self.nonce = nonce
        self.receiver_id = receiver_id
        self.max_block_height = max_block_height
        self.sender_id = sender_id
        self.actions = actions
        self.public_key = public_key
    }
}

public struct DeleteAccountAction: Codable, Sendable {
    public let beneficiary_id: AccountId

    public init(beneficiary_id: AccountId) {
        self.beneficiary_id = beneficiary_id
    }
}

public struct DeleteKeyAction: Codable, Sendable {
    public let public_key: AnyCodable

    public init(public_key: AnyCodable) {
        self.public_key = public_key
    }
}

/// Deploy contract action
public struct DeployContractAction: Codable, Sendable {
    public let code: String

    public init(code: String) {
        self.code = code
    }
}

/// Deploy global contract action
public struct DeployGlobalContractAction: Codable, Sendable {
    public let code: String
    public let deploy_mode: GlobalContractDeployMode

    public init(code: String, deploy_mode: GlobalContractDeployMode) {
        self.code = code
        self.deploy_mode = deploy_mode
    }
}

public struct DetailedDebugStatus: Codable, Sendable {
    public let current_header_head_status: BlockStatusView
    public let sync_status: String
    public let catchup_status: [AnyCodable]
    public let current_head_status: BlockStatusView
    public let network_info: NetworkInfoView
    public let block_production_delay_millis: UInt64

    public init(current_header_head_status: BlockStatusView, sync_status: String, catchup_status: [AnyCodable], current_head_status: BlockStatusView, network_info: NetworkInfoView, block_production_delay_millis: UInt64) {
        self.current_header_head_status = current_header_head_status
        self.sync_status = sync_status
        self.catchup_status = catchup_status
        self.current_head_status = current_head_status
        self.network_info = network_info
        self.block_production_delay_millis = block_production_delay_millis
    }
}

public enum Direction: Codable, Sendable {
    case Left
    case Right
}

/// Configures how to dump state to external storage.
public struct DumpConfig: Codable, Sendable {
    public let location: AnyCodable
    public let credentials_file: String?
    public let iteration_delay: AnyCodable?
    public let restart_dump_for_shards: [AnyCodable]?

    public init(location: AnyCodable, credentials_file: String? = nil, iteration_delay: AnyCodable? = nil, restart_dump_for_shards: [AnyCodable]? = nil) {
        self.location = location
        self.credentials_file = credentials_file
        self.iteration_delay = iteration_delay
        self.restart_dump_for_shards = restart_dump_for_shards
    }
}

public struct DurationAsStdSchemaProvider: Codable, Sendable {
    public let nanos: Int
    public let secs: Int

    public init(nanos: Int, secs: Int) {
        self.nanos = nanos
        self.secs = secs
    }
}

/// Epoch identifier -- wrapped hash, to make it easier to distinguish.
EpochId of epoch T is the hash of last block in T-2
EpochId of first two epochs is 0
public struct EpochId: Codable, Sendable {
}

public struct EpochSyncConfig: Codable, Sendable {
    public let disable_epoch_sync_for_bootstrapping: Bool?
    public let timeout_for_epoch_sync: AnyCodable
    public let ignore_epoch_sync_network_requests: Bool?
    public let epoch_sync_horizon: UInt64

    public init(disable_epoch_sync_for_bootstrapping: Bool? = nil, timeout_for_epoch_sync: AnyCodable, ignore_epoch_sync_network_requests: Bool? = nil, epoch_sync_horizon: UInt64) {
        self.disable_epoch_sync_for_bootstrapping = disable_epoch_sync_for_bootstrapping
        self.timeout_for_epoch_sync = timeout_for_epoch_sync
        self.ignore_epoch_sync_network_requests = ignore_epoch_sync_network_requests
        self.epoch_sync_horizon = epoch_sync_horizon
    }
}

public struct ExecutionMetadataView: Codable, Sendable {
    public let version: Int
    public let gas_profile: [AnyCodable]?

    public init(version: Int, gas_profile: [AnyCodable]? = nil) {
        self.version = version
        self.gas_profile = gas_profile
    }
}

public struct ExecutionOutcomeView: Codable, Sendable {
    public let metadata: AnyCodable?
    public let logs: [String]
    public let executor_id: AnyCodable
    public let gas_burnt: AnyCodable
    public let receipt_ids: [AnyCodable]
    public let tokens_burnt: String
    public let status: AnyCodable

    public init(metadata: AnyCodable? = nil, logs: [String], executor_id: AnyCodable, gas_burnt: AnyCodable, receipt_ids: [AnyCodable], tokens_burnt: String, status: AnyCodable) {
        self.metadata = metadata
        self.logs = logs
        self.executor_id = executor_id
        self.gas_burnt = gas_burnt
        self.receipt_ids = receipt_ids
        self.tokens_burnt = tokens_burnt
        self.status = status
    }
}

public struct ExecutionOutcomeWithIdView: Codable, Sendable {
    public let proof: [AnyCodable]
    public let block_hash: CryptoHash
    public let outcome: ExecutionOutcomeView
    public let id: CryptoHash

    public init(proof: [AnyCodable], block_hash: CryptoHash, outcome: ExecutionOutcomeView, id: CryptoHash) {
        self.proof = proof
        self.block_hash = block_hash
        self.outcome = outcome
        self.id = id
    }
}

public enum ExecutionStatusView: Codable, Sendable {
    case Unknown
    case Failure(TxExecutionError)
    case SuccessValue(String)
    case SuccessReceiptId(CryptoHash)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let failure = dict["Failure"] {
                self = .Failure(try failure.decode(TxExecutionError.self))
            } else             if let successvalue = dict["SuccessValue"] {
                self = .SuccessValue(try successvalue.decode(String.self))
            } else             if let successreceiptid = dict["SuccessReceiptId"] {
                self = .SuccessReceiptId(try successreceiptid.decode(CryptoHash.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ExecutionStatusView")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "Unknown": self = .Unknown
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ExecutionStatusView: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ExecutionStatusView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .Unknown:
            try container.encode("Unknown")
        case .Failure(let value):
            try container.encode(["Failure": AnyCodable(value)])
        case .SuccessValue(let value):
            try container.encode(["SuccessValue": AnyCodable(value)])
        case .SuccessReceiptId(let value):
            try container.encode(["SuccessReceiptId": AnyCodable(value)])
        }
    }
}

/// Typed view of ExtCostsConfig to preserve JSON output field names in protocol
config RPC output.
public struct ExtCostsConfigView: Codable, Sendable {
    public let yield_create_byte: AnyCodable
    public let storage_iter_create_to_byte: AnyCodable
    public let write_memory_base: AnyCodable
    public let yield_resume_base: AnyCodable
    public let yield_resume_byte: AnyCodable
    public let write_register_byte: AnyCodable
    public let alt_bn128_pairing_check_base: AnyCodable
    public let alt_bn128_g1_sum_base: AnyCodable
    public let promise_and_per_promise: AnyCodable
    public let storage_has_key_base: AnyCodable
    public let promise_return: AnyCodable
    public let storage_write_evicted_byte: AnyCodable
    public let yield_create_base: AnyCodable
    public let promise_and_base: AnyCodable
    public let ed25519_verify_byte: AnyCodable
    public let keccak256_base: AnyCodable
    public let log_byte: AnyCodable
    public let storage_has_key_byte: AnyCodable
    public let storage_large_read_overhead_base: AnyCodable
    public let bls12381_pairing_element: NearGas
    public let storage_iter_create_from_byte: AnyCodable
    public let utf16_decoding_base: AnyCodable
    public let ripemd160_base: AnyCodable
    public let bls12381_map_fp_to_g1_base: NearGas
    public let base: AnyCodable
    public let storage_read_key_byte: AnyCodable
    public let storage_write_key_byte: AnyCodable
    public let write_memory_byte: AnyCodable
    public let storage_iter_next_base: AnyCodable
    public let bls12381_p1_decompress_base: NearGas
    public let storage_iter_create_range_base: AnyCodable
    public let bls12381_pairing_base: NearGas
    public let sha256_byte: AnyCodable
    public let alt_bn128_g1_sum_element: AnyCodable
    public let utf8_decoding_base: AnyCodable
    public let storage_remove_key_byte: AnyCodable
    public let storage_iter_next_key_byte: AnyCodable
    public let alt_bn128_g1_multiexp_element: AnyCodable
    public let alt_bn128_g1_multiexp_base: AnyCodable
    public let bls12381_p2_decompress_base: NearGas
    public let keccak512_byte: AnyCodable
    public let bls12381_map_fp2_to_g2_element: NearGas
    public let bls12381_p1_decompress_element: NearGas
    public let storage_remove_base: AnyCodable
    public let storage_write_base: AnyCodable
    public let sha256_base: AnyCodable
    public let utf16_decoding_byte: AnyCodable
    public let log_base: AnyCodable
    public let contract_compile_bytes: NearGas
    public let storage_write_value_byte: AnyCodable
    public let bls12381_g1_multiexp_base: NearGas
    public let utf8_decoding_byte: AnyCodable
    public let bls12381_p1_sum_element: NearGas
    public let ripemd160_block: AnyCodable
    public let bls12381_p2_decompress_element: NearGas
    public let bls12381_g2_multiexp_base: NearGas
    public let storage_read_value_byte: AnyCodable
    public let keccak256_byte: AnyCodable
    public let contract_loading_base: AnyCodable
    public let read_register_byte: AnyCodable
    public let contract_loading_bytes: AnyCodable
    public let bls12381_p2_sum_base: NearGas
    public let read_register_base: AnyCodable
    public let alt_bn128_pairing_check_element: AnyCodable
    public let storage_remove_ret_value_byte: AnyCodable
    public let read_memory_byte: AnyCodable
    public let contract_compile_base: NearGas
    public let bls12381_map_fp2_to_g2_base: NearGas
    public let storage_iter_next_value_byte: AnyCodable
    public let bls12381_p1_sum_base: NearGas
    public let keccak512_base: AnyCodable
    public let ecrecover_base: AnyCodable
    public let validator_stake_base: AnyCodable
    public let storage_iter_create_prefix_byte: AnyCodable
    public let ed25519_verify_base: AnyCodable
    public let touching_trie_node: AnyCodable
    public let storage_large_read_overhead_byte: AnyCodable
    public let storage_read_base: AnyCodable
    public let validator_total_stake_base: AnyCodable
    public let bls12381_g2_multiexp_element: NearGas
    public let bls12381_map_fp_to_g1_element: NearGas
    public let write_register_base: AnyCodable
    public let read_memory_base: AnyCodable
    public let bls12381_g1_multiexp_element: NearGas
    public let storage_iter_create_prefix_base: AnyCodable
    public let read_cached_trie_node: AnyCodable
    public let bls12381_p2_sum_element: NearGas

    public init(yield_create_byte: AnyCodable, storage_iter_create_to_byte: AnyCodable, write_memory_base: AnyCodable, yield_resume_base: AnyCodable, yield_resume_byte: AnyCodable, write_register_byte: AnyCodable, alt_bn128_pairing_check_base: AnyCodable, alt_bn128_g1_sum_base: AnyCodable, promise_and_per_promise: AnyCodable, storage_has_key_base: AnyCodable, promise_return: AnyCodable, storage_write_evicted_byte: AnyCodable, yield_create_base: AnyCodable, promise_and_base: AnyCodable, ed25519_verify_byte: AnyCodable, keccak256_base: AnyCodable, log_byte: AnyCodable, storage_has_key_byte: AnyCodable, storage_large_read_overhead_base: AnyCodable, bls12381_pairing_element: NearGas, storage_iter_create_from_byte: AnyCodable, utf16_decoding_base: AnyCodable, ripemd160_base: AnyCodable, bls12381_map_fp_to_g1_base: NearGas, base: AnyCodable, storage_read_key_byte: AnyCodable, storage_write_key_byte: AnyCodable, write_memory_byte: AnyCodable, storage_iter_next_base: AnyCodable, bls12381_p1_decompress_base: NearGas, storage_iter_create_range_base: AnyCodable, bls12381_pairing_base: NearGas, sha256_byte: AnyCodable, alt_bn128_g1_sum_element: AnyCodable, utf8_decoding_base: AnyCodable, storage_remove_key_byte: AnyCodable, storage_iter_next_key_byte: AnyCodable, alt_bn128_g1_multiexp_element: AnyCodable, alt_bn128_g1_multiexp_base: AnyCodable, bls12381_p2_decompress_base: NearGas, keccak512_byte: AnyCodable, bls12381_map_fp2_to_g2_element: NearGas, bls12381_p1_decompress_element: NearGas, storage_remove_base: AnyCodable, storage_write_base: AnyCodable, sha256_base: AnyCodable, utf16_decoding_byte: AnyCodable, log_base: AnyCodable, contract_compile_bytes: NearGas, storage_write_value_byte: AnyCodable, bls12381_g1_multiexp_base: NearGas, utf8_decoding_byte: AnyCodable, bls12381_p1_sum_element: NearGas, ripemd160_block: AnyCodable, bls12381_p2_decompress_element: NearGas, bls12381_g2_multiexp_base: NearGas, storage_read_value_byte: AnyCodable, keccak256_byte: AnyCodable, contract_loading_base: AnyCodable, read_register_byte: AnyCodable, contract_loading_bytes: AnyCodable, bls12381_p2_sum_base: NearGas, read_register_base: AnyCodable, alt_bn128_pairing_check_element: AnyCodable, storage_remove_ret_value_byte: AnyCodable, read_memory_byte: AnyCodable, contract_compile_base: NearGas, bls12381_map_fp2_to_g2_base: NearGas, storage_iter_next_value_byte: AnyCodable, bls12381_p1_sum_base: NearGas, keccak512_base: AnyCodable, ecrecover_base: AnyCodable, validator_stake_base: AnyCodable, storage_iter_create_prefix_byte: AnyCodable, ed25519_verify_base: AnyCodable, touching_trie_node: AnyCodable, storage_large_read_overhead_byte: AnyCodable, storage_read_base: AnyCodable, validator_total_stake_base: AnyCodable, bls12381_g2_multiexp_element: NearGas, bls12381_map_fp_to_g1_element: NearGas, write_register_base: AnyCodable, read_memory_base: AnyCodable, bls12381_g1_multiexp_element: NearGas, storage_iter_create_prefix_base: AnyCodable, read_cached_trie_node: AnyCodable, bls12381_p2_sum_element: NearGas) {
        self.yield_create_byte = yield_create_byte
        self.storage_iter_create_to_byte = storage_iter_create_to_byte
        self.write_memory_base = write_memory_base
        self.yield_resume_base = yield_resume_base
        self.yield_resume_byte = yield_resume_byte
        self.write_register_byte = write_register_byte
        self.alt_bn128_pairing_check_base = alt_bn128_pairing_check_base
        self.alt_bn128_g1_sum_base = alt_bn128_g1_sum_base
        self.promise_and_per_promise = promise_and_per_promise
        self.storage_has_key_base = storage_has_key_base
        self.promise_return = promise_return
        self.storage_write_evicted_byte = storage_write_evicted_byte
        self.yield_create_base = yield_create_base
        self.promise_and_base = promise_and_base
        self.ed25519_verify_byte = ed25519_verify_byte
        self.keccak256_base = keccak256_base
        self.log_byte = log_byte
        self.storage_has_key_byte = storage_has_key_byte
        self.storage_large_read_overhead_base = storage_large_read_overhead_base
        self.bls12381_pairing_element = bls12381_pairing_element
        self.storage_iter_create_from_byte = storage_iter_create_from_byte
        self.utf16_decoding_base = utf16_decoding_base
        self.ripemd160_base = ripemd160_base
        self.bls12381_map_fp_to_g1_base = bls12381_map_fp_to_g1_base
        self.base = base
        self.storage_read_key_byte = storage_read_key_byte
        self.storage_write_key_byte = storage_write_key_byte
        self.write_memory_byte = write_memory_byte
        self.storage_iter_next_base = storage_iter_next_base
        self.bls12381_p1_decompress_base = bls12381_p1_decompress_base
        self.storage_iter_create_range_base = storage_iter_create_range_base
        self.bls12381_pairing_base = bls12381_pairing_base
        self.sha256_byte = sha256_byte
        self.alt_bn128_g1_sum_element = alt_bn128_g1_sum_element
        self.utf8_decoding_base = utf8_decoding_base
        self.storage_remove_key_byte = storage_remove_key_byte
        self.storage_iter_next_key_byte = storage_iter_next_key_byte
        self.alt_bn128_g1_multiexp_element = alt_bn128_g1_multiexp_element
        self.alt_bn128_g1_multiexp_base = alt_bn128_g1_multiexp_base
        self.bls12381_p2_decompress_base = bls12381_p2_decompress_base
        self.keccak512_byte = keccak512_byte
        self.bls12381_map_fp2_to_g2_element = bls12381_map_fp2_to_g2_element
        self.bls12381_p1_decompress_element = bls12381_p1_decompress_element
        self.storage_remove_base = storage_remove_base
        self.storage_write_base = storage_write_base
        self.sha256_base = sha256_base
        self.utf16_decoding_byte = utf16_decoding_byte
        self.log_base = log_base
        self.contract_compile_bytes = contract_compile_bytes
        self.storage_write_value_byte = storage_write_value_byte
        self.bls12381_g1_multiexp_base = bls12381_g1_multiexp_base
        self.utf8_decoding_byte = utf8_decoding_byte
        self.bls12381_p1_sum_element = bls12381_p1_sum_element
        self.ripemd160_block = ripemd160_block
        self.bls12381_p2_decompress_element = bls12381_p2_decompress_element
        self.bls12381_g2_multiexp_base = bls12381_g2_multiexp_base
        self.storage_read_value_byte = storage_read_value_byte
        self.keccak256_byte = keccak256_byte
        self.contract_loading_base = contract_loading_base
        self.read_register_byte = read_register_byte
        self.contract_loading_bytes = contract_loading_bytes
        self.bls12381_p2_sum_base = bls12381_p2_sum_base
        self.read_register_base = read_register_base
        self.alt_bn128_pairing_check_element = alt_bn128_pairing_check_element
        self.storage_remove_ret_value_byte = storage_remove_ret_value_byte
        self.read_memory_byte = read_memory_byte
        self.contract_compile_base = contract_compile_base
        self.bls12381_map_fp2_to_g2_base = bls12381_map_fp2_to_g2_base
        self.storage_iter_next_value_byte = storage_iter_next_value_byte
        self.bls12381_p1_sum_base = bls12381_p1_sum_base
        self.keccak512_base = keccak512_base
        self.ecrecover_base = ecrecover_base
        self.validator_stake_base = validator_stake_base
        self.storage_iter_create_prefix_byte = storage_iter_create_prefix_byte
        self.ed25519_verify_base = ed25519_verify_base
        self.touching_trie_node = touching_trie_node
        self.storage_large_read_overhead_byte = storage_large_read_overhead_byte
        self.storage_read_base = storage_read_base
        self.validator_total_stake_base = validator_total_stake_base
        self.bls12381_g2_multiexp_element = bls12381_g2_multiexp_element
        self.bls12381_map_fp_to_g1_element = bls12381_map_fp_to_g1_element
        self.write_register_base = write_register_base
        self.read_memory_base = read_memory_base
        self.bls12381_g1_multiexp_element = bls12381_g1_multiexp_element
        self.storage_iter_create_prefix_base = storage_iter_create_prefix_base
        self.read_cached_trie_node = read_cached_trie_node
        self.bls12381_p2_sum_element = bls12381_p2_sum_element
    }
}

public struct ExternalStorageConfig: Codable, Sendable {
    public let location: AnyCodable
    public let num_concurrent_requests_during_catchup: Int?
    public let num_concurrent_requests: Int?
    public let external_storage_fallback_threshold: UInt64?

    public init(location: AnyCodable, num_concurrent_requests_during_catchup: Int? = nil, num_concurrent_requests: Int? = nil, external_storage_fallback_threshold: UInt64? = nil) {
        self.location = location
        self.num_concurrent_requests_during_catchup = num_concurrent_requests_during_catchup
        self.num_concurrent_requests = num_concurrent_requests
        self.external_storage_fallback_threshold = external_storage_fallback_threshold
    }
}

public enum ExternalStorageLocation: Codable, Sendable {
    case S3(AnyCodable)
    case Filesystem(AnyCodable)
    case GCS(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let s3 = dict["S3"] {
                self = .S3(try s3.decode(AnyCodable.self))
            } else             if let filesystem = dict["Filesystem"] {
                self = .Filesystem(try filesystem.decode(AnyCodable.self))
            } else             if let gcs = dict["GCS"] {
                self = .GCS(try gcs.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ExternalStorageLocation")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ExternalStorageLocation")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .S3(let value):
            try container.encode(["S3": AnyCodable(value)])
        case .Filesystem(let value):
            try container.encode(["Filesystem": AnyCodable(value)])
        case .GCS(let value):
            try container.encode(["GCS": AnyCodable(value)])
        }
    }
}

/// Costs associated with an object that can only be sent over the network (and executed
by the receiver).
NOTE: `send_sir` or `send_not_sir` fees are usually burned when the item is being created.
And `execution` fee is burned when the item is being executed.
public struct Fee: Codable, Sendable {
    public let send_sir: AnyCodable
    public let execution: AnyCodable
    public let send_not_sir: AnyCodable

    public init(send_sir: AnyCodable, execution: AnyCodable, send_not_sir: AnyCodable) {
        self.send_sir = send_sir
        self.execution = execution
        self.send_not_sir = send_not_sir
    }
}

/// Execution outcome of the transaction and all the subsequent receipts.
Could be not finalized yet
public struct FinalExecutionOutcomeView: Codable, Sendable {
    public let receipts_outcome: [AnyCodable]
    public let transaction_outcome: AnyCodable
    public let transaction: AnyCodable
    public let status: AnyCodable

    public init(receipts_outcome: [AnyCodable], transaction_outcome: AnyCodable, transaction: AnyCodable, status: AnyCodable) {
        self.receipts_outcome = receipts_outcome
        self.transaction_outcome = transaction_outcome
        self.transaction = transaction
        self.status = status
    }
}

/// Final execution outcome of the transaction and all of subsequent the receipts. Also includes
the generated receipt.
public struct FinalExecutionOutcomeWithReceiptView: Codable, Sendable {
    public let receipts_outcome: [AnyCodable]
    public let transaction_outcome: AnyCodable
    public let transaction: AnyCodable
    public let receipts: [AnyCodable]
    public let status: AnyCodable

    public init(receipts_outcome: [AnyCodable], transaction_outcome: AnyCodable, transaction: AnyCodable, receipts: [AnyCodable], status: AnyCodable) {
        self.receipts_outcome = receipts_outcome
        self.transaction_outcome = transaction_outcome
        self.transaction = transaction
        self.receipts = receipts
        self.status = status
    }
}

public enum FinalExecutionStatus: Codable, Sendable {
    case NotStarted
    case Started
    case Failure(TxExecutionError)
    case SuccessValue(String)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let failure = dict["Failure"] {
                self = .Failure(try failure.decode(TxExecutionError.self))
            } else             if let successvalue = dict["SuccessValue"] {
                self = .SuccessValue(try successvalue.decode(String.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid FinalExecutionStatus")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "NotStarted": self = .NotStarted
            case "Started": self = .Started
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid FinalExecutionStatus: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid FinalExecutionStatus")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .NotStarted:
            try container.encode("NotStarted")
        case .Started:
            try container.encode("Started")
        case .Failure(let value):
            try container.encode(["Failure": AnyCodable(value)])
        case .SuccessValue(let value):
            try container.encode(["SuccessValue": AnyCodable(value)])
        }
    }
}

/// Different types of finality.
public enum Finality: Codable, Sendable {
    case optimistic
    case near-final
    case final
}

/// This type is used to mark function arguments.

NOTE: The main reason for this to exist (except the type-safety) is that the value is
transparently serialized and deserialized as a base64-encoded string when serde is used
(serde_json).
public typealias FunctionArgs = String

public struct FunctionCallAction: Codable, Sendable {
    public let method_name: String
    public let deposit: String
    public let gas: NearGas
    public let args: String

    public init(method_name: String, deposit: String, gas: NearGas, args: String) {
        self.method_name = method_name
        self.deposit = deposit
        self.gas = gas
        self.args = args
    }
}

/// Serializable version of `near-vm-runner::FunctionCallError`.

Must never reorder/remove elements, can only add new variants at the end (but do that very
carefully). It describes stable serialization format, and only used by serialization logic.
public enum FunctionCallError: Codable, Sendable {
    case WasmUnknownError
    case CompilationError(CompilationError)
    case LinkError(AnyCodable)
    case MethodResolveError(MethodResolveError)
    case WasmTrap(WasmTrap)
    case HostError(HostError)
    case ExecutionError(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let compilationerror = dict["CompilationError"] {
                self = .CompilationError(try compilationerror.decode(CompilationError.self))
            } else             if let linkerror = dict["LinkError"] {
                self = .LinkError(try linkerror.decode(AnyCodable.self))
            } else             if let methodresolveerror = dict["MethodResolveError"] {
                self = .MethodResolveError(try methodresolveerror.decode(MethodResolveError.self))
            } else             if let wasmtrap = dict["WasmTrap"] {
                self = .WasmTrap(try wasmtrap.decode(WasmTrap.self))
            } else             if let hosterror = dict["HostError"] {
                self = .HostError(try hosterror.decode(HostError.self))
            } else             if let executionerror = dict["ExecutionError"] {
                self = .ExecutionError(try executionerror.decode(String.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid FunctionCallError")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "WasmUnknownError": self = .WasmUnknownError
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid FunctionCallError: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid FunctionCallError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .WasmUnknownError:
            try container.encode("WasmUnknownError")
        case .CompilationError(let value):
            try container.encode(["CompilationError": AnyCodable(value)])
        case .LinkError(let value):
            try container.encode(["LinkError": AnyCodable(value)])
        case .MethodResolveError(let value):
            try container.encode(["MethodResolveError": AnyCodable(value)])
        case .WasmTrap(let value):
            try container.encode(["WasmTrap": AnyCodable(value)])
        case .HostError(let value):
            try container.encode(["HostError": AnyCodable(value)])
        case .ExecutionError(let value):
            try container.encode(["ExecutionError": AnyCodable(value)])
        }
    }
}

/// Grants limited permission to make transactions with FunctionCallActions
The permission can limit the allowed balance to be spent on the prepaid gas.
It also restrict the account ID of the receiver for this function call.
It also can restrict the method name for the allowed function calls.
public struct FunctionCallPermission: Codable, Sendable {
    public let receiver_id: String
    public let allowance: String?
    public let method_names: [String]

    public init(receiver_id: String, allowance: String? = nil, method_names: [String]) {
        self.receiver_id = receiver_id
        self.allowance = allowance
        self.method_names = method_names
    }
}

/// Configuration for garbage collection.
public struct GCConfig: Codable, Sendable {
    public let gc_step_period: AnyCodable?
    public let gc_fork_clean_step: UInt64?
    public let gc_num_epochs_to_keep: UInt64?
    public let gc_blocks_limit: UInt64?

    public init(gc_step_period: AnyCodable? = nil, gc_fork_clean_step: UInt64? = nil, gc_num_epochs_to_keep: UInt64? = nil, gc_blocks_limit: UInt64? = nil) {
        self.gc_step_period = gc_step_period
        self.gc_fork_clean_step = gc_fork_clean_step
        self.gc_num_epochs_to_keep = gc_num_epochs_to_keep
        self.gc_blocks_limit = gc_blocks_limit
    }
}

public struct GasKeyView: Codable, Sendable {
    public let balance: Int
    public let num_nonces: Int
    public let permission: AccessKeyPermissionView

    public init(balance: Int, num_nonces: Int, permission: AccessKeyPermissionView) {
        self.balance = balance
        self.num_nonces = num_nonces
        self.permission = permission
    }
}

public struct GenesisConfig: Codable, Sendable {
    public let gas_price_adjustment_rate: [Int]
    public let dynamic_resharding: Bool
    public let num_blocks_per_year: UInt64
    public let genesis_height: UInt64
    public let online_max_threshold: [Int]?
    public let minimum_validators_per_shard: UInt64?
    public let total_supply: String
    public let chunk_producer_assignment_changes_limit: UInt64?
    public let minimum_stake_divisor: UInt64?
    public let protocol_reward_rate: [Int]
    public let validators: [AnyCodable]
    public let protocol_treasury_account: AnyCodable
    public let shuffle_shard_assignment_for_chunk_producers: Bool?
    public let protocol_version: Int
    public let chunk_producer_kickout_threshold: Int
    public let minimum_stake_ratio: [Int]?
    public let avg_hidden_validator_seats_per_shard: [UInt64]
    public let min_gas_price: String
    public let num_block_producer_seats: UInt64
    public let max_inflation_rate: [Int]
    public let epoch_length: UInt64
    public let gas_limit: AnyCodable
    public let fishermen_threshold: String
    public let target_validator_mandates_per_shard: UInt64?
    public let num_block_producer_seats_per_shard: [UInt64]
    public let online_min_threshold: [Int]?
    public let protocol_upgrade_stake_threshold: [Int]?
    public let genesis_time: String
    public let num_chunk_producer_seats: UInt64?
    public let num_chunk_only_producer_seats: UInt64?
    public let shard_layout: AnyCodable?
    public let max_gas_price: String
    public let use_production_config: Bool?
    public let max_kickout_stake_perc: Int?
    public let num_chunk_validator_seats: UInt64?
    public let block_producer_kickout_threshold: Int
    public let transaction_validity_period: UInt64
    public let chunk_validator_only_kickout_threshold: Int?
    public let chain_id: String

    public init(gas_price_adjustment_rate: [Int], dynamic_resharding: Bool, num_blocks_per_year: UInt64, genesis_height: UInt64, online_max_threshold: [Int]? = nil, minimum_validators_per_shard: UInt64? = nil, total_supply: String, chunk_producer_assignment_changes_limit: UInt64? = nil, minimum_stake_divisor: UInt64? = nil, protocol_reward_rate: [Int], validators: [AnyCodable], protocol_treasury_account: AnyCodable, shuffle_shard_assignment_for_chunk_producers: Bool? = nil, protocol_version: Int, chunk_producer_kickout_threshold: Int, minimum_stake_ratio: [Int]? = nil, avg_hidden_validator_seats_per_shard: [UInt64], min_gas_price: String, num_block_producer_seats: UInt64, max_inflation_rate: [Int], epoch_length: UInt64, gas_limit: AnyCodable, fishermen_threshold: String, target_validator_mandates_per_shard: UInt64? = nil, num_block_producer_seats_per_shard: [UInt64], online_min_threshold: [Int]? = nil, protocol_upgrade_stake_threshold: [Int]? = nil, genesis_time: String, num_chunk_producer_seats: UInt64? = nil, num_chunk_only_producer_seats: UInt64? = nil, shard_layout: AnyCodable? = nil, max_gas_price: String, use_production_config: Bool? = nil, max_kickout_stake_perc: Int? = nil, num_chunk_validator_seats: UInt64? = nil, block_producer_kickout_threshold: Int, transaction_validity_period: UInt64, chunk_validator_only_kickout_threshold: Int? = nil, chain_id: String) {
        self.gas_price_adjustment_rate = gas_price_adjustment_rate
        self.dynamic_resharding = dynamic_resharding
        self.num_blocks_per_year = num_blocks_per_year
        self.genesis_height = genesis_height
        self.online_max_threshold = online_max_threshold
        self.minimum_validators_per_shard = minimum_validators_per_shard
        self.total_supply = total_supply
        self.chunk_producer_assignment_changes_limit = chunk_producer_assignment_changes_limit
        self.minimum_stake_divisor = minimum_stake_divisor
        self.protocol_reward_rate = protocol_reward_rate
        self.validators = validators
        self.protocol_treasury_account = protocol_treasury_account
        self.shuffle_shard_assignment_for_chunk_producers = shuffle_shard_assignment_for_chunk_producers
        self.protocol_version = protocol_version
        self.chunk_producer_kickout_threshold = chunk_producer_kickout_threshold
        self.minimum_stake_ratio = minimum_stake_ratio
        self.avg_hidden_validator_seats_per_shard = avg_hidden_validator_seats_per_shard
        self.min_gas_price = min_gas_price
        self.num_block_producer_seats = num_block_producer_seats
        self.max_inflation_rate = max_inflation_rate
        self.epoch_length = epoch_length
        self.gas_limit = gas_limit
        self.fishermen_threshold = fishermen_threshold
        self.target_validator_mandates_per_shard = target_validator_mandates_per_shard
        self.num_block_producer_seats_per_shard = num_block_producer_seats_per_shard
        self.online_min_threshold = online_min_threshold
        self.protocol_upgrade_stake_threshold = protocol_upgrade_stake_threshold
        self.genesis_time = genesis_time
        self.num_chunk_producer_seats = num_chunk_producer_seats
        self.num_chunk_only_producer_seats = num_chunk_only_producer_seats
        self.shard_layout = shard_layout
        self.max_gas_price = max_gas_price
        self.use_production_config = use_production_config
        self.max_kickout_stake_perc = max_kickout_stake_perc
        self.num_chunk_validator_seats = num_chunk_validator_seats
        self.block_producer_kickout_threshold = block_producer_kickout_threshold
        self.transaction_validity_period = transaction_validity_period
        self.chunk_validator_only_kickout_threshold = chunk_validator_only_kickout_threshold
        self.chain_id = chain_id
    }
}

public enum GenesisConfigRequest: Codable, Sendable {
}

public enum GlobalContractDeployMode: Codable, Sendable {
    case CodeHash
    case AccountId
}

public enum GlobalContractIdentifier: Codable, Sendable {
    case CodeHash(CryptoHash)
    case AccountId(AccountId)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let codehash = dict["CodeHash"] {
                self = .CodeHash(try codehash.decode(CryptoHash.self))
            } else             if let accountid = dict["AccountId"] {
                self = .AccountId(try accountid.decode(AccountId.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid GlobalContractIdentifier")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid GlobalContractIdentifier")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .CodeHash(let value):
            try container.encode(["CodeHash": AnyCodable(value)])
        case .AccountId(let value):
            try container.encode(["AccountId": AnyCodable(value)])
        }
    }
}

public enum HostError: Codable, Sendable {
    case BadUTF16
    case BadUTF8
    case GasExceeded
    case GasLimitExceeded
    case BalanceExceeded
    case EmptyMethodName
    case GuestPanic(AnyCodable)
    case IntegerOverflow
    case InvalidPromiseIndex(AnyCodable)
    case CannotAppendActionToJointPromise
    case CannotReturnJointPromise
    case InvalidPromiseResultIndex(AnyCodable)
    case InvalidRegisterId(AnyCodable)
    case IteratorWasInvalidated(AnyCodable)
    case MemoryAccessViolation
    case InvalidReceiptIndex(AnyCodable)
    case InvalidIteratorIndex(AnyCodable)
    case InvalidAccountId
    case InvalidMethodName
    case InvalidPublicKey
    case ProhibitedInView(AnyCodable)
    case NumberOfLogsExceeded(AnyCodable)
    case KeyLengthExceeded(AnyCodable)
    case ValueLengthExceeded(AnyCodable)
    case TotalLogLengthExceeded(AnyCodable)
    case NumberPromisesExceeded(AnyCodable)
    case NumberInputDataDependenciesExceeded(AnyCodable)
    case ReturnedValueLengthExceeded(AnyCodable)
    case ContractSizeExceeded(AnyCodable)
    case Deprecated(AnyCodable)
    case ECRecoverError(AnyCodable)
    case AltBn128InvalidInput(AnyCodable)
    case Ed25519VerifyInvalidInput(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let guestpanic = dict["GuestPanic"] {
                self = .GuestPanic(try guestpanic.decode(AnyCodable.self))
            } else             if let invalidpromiseindex = dict["InvalidPromiseIndex"] {
                self = .InvalidPromiseIndex(try invalidpromiseindex.decode(AnyCodable.self))
            } else             if let invalidpromiseresultindex = dict["InvalidPromiseResultIndex"] {
                self = .InvalidPromiseResultIndex(try invalidpromiseresultindex.decode(AnyCodable.self))
            } else             if let invalidregisterid = dict["InvalidRegisterId"] {
                self = .InvalidRegisterId(try invalidregisterid.decode(AnyCodable.self))
            } else             if let iteratorwasinvalidated = dict["IteratorWasInvalidated"] {
                self = .IteratorWasInvalidated(try iteratorwasinvalidated.decode(AnyCodable.self))
            } else             if let invalidreceiptindex = dict["InvalidReceiptIndex"] {
                self = .InvalidReceiptIndex(try invalidreceiptindex.decode(AnyCodable.self))
            } else             if let invaliditeratorindex = dict["InvalidIteratorIndex"] {
                self = .InvalidIteratorIndex(try invaliditeratorindex.decode(AnyCodable.self))
            } else             if let prohibitedinview = dict["ProhibitedInView"] {
                self = .ProhibitedInView(try prohibitedinview.decode(AnyCodable.self))
            } else             if let numberoflogsexceeded = dict["NumberOfLogsExceeded"] {
                self = .NumberOfLogsExceeded(try numberoflogsexceeded.decode(AnyCodable.self))
            } else             if let keylengthexceeded = dict["KeyLengthExceeded"] {
                self = .KeyLengthExceeded(try keylengthexceeded.decode(AnyCodable.self))
            } else             if let valuelengthexceeded = dict["ValueLengthExceeded"] {
                self = .ValueLengthExceeded(try valuelengthexceeded.decode(AnyCodable.self))
            } else             if let totalloglengthexceeded = dict["TotalLogLengthExceeded"] {
                self = .TotalLogLengthExceeded(try totalloglengthexceeded.decode(AnyCodable.self))
            } else             if let numberpromisesexceeded = dict["NumberPromisesExceeded"] {
                self = .NumberPromisesExceeded(try numberpromisesexceeded.decode(AnyCodable.self))
            } else             if let numberinputdatadependenciesexceeded = dict["NumberInputDataDependenciesExceeded"] {
                self = .NumberInputDataDependenciesExceeded(try numberinputdatadependenciesexceeded.decode(AnyCodable.self))
            } else             if let returnedvaluelengthexceeded = dict["ReturnedValueLengthExceeded"] {
                self = .ReturnedValueLengthExceeded(try returnedvaluelengthexceeded.decode(AnyCodable.self))
            } else             if let contractsizeexceeded = dict["ContractSizeExceeded"] {
                self = .ContractSizeExceeded(try contractsizeexceeded.decode(AnyCodable.self))
            } else             if let deprecated = dict["Deprecated"] {
                self = .Deprecated(try deprecated.decode(AnyCodable.self))
            } else             if let ecrecovererror = dict["ECRecoverError"] {
                self = .ECRecoverError(try ecrecovererror.decode(AnyCodable.self))
            } else             if let altbn128invalidinput = dict["AltBn128InvalidInput"] {
                self = .AltBn128InvalidInput(try altbn128invalidinput.decode(AnyCodable.self))
            } else             if let ed25519verifyinvalidinput = dict["Ed25519VerifyInvalidInput"] {
                self = .Ed25519VerifyInvalidInput(try ed25519verifyinvalidinput.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid HostError")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "BadUTF16": self = .BadUTF16
            case "BadUTF8": self = .BadUTF8
            case "GasExceeded": self = .GasExceeded
            case "GasLimitExceeded": self = .GasLimitExceeded
            case "BalanceExceeded": self = .BalanceExceeded
            case "EmptyMethodName": self = .EmptyMethodName
            case "IntegerOverflow": self = .IntegerOverflow
            case "CannotAppendActionToJointPromise": self = .CannotAppendActionToJointPromise
            case "CannotReturnJointPromise": self = .CannotReturnJointPromise
            case "MemoryAccessViolation": self = .MemoryAccessViolation
            case "InvalidAccountId": self = .InvalidAccountId
            case "InvalidMethodName": self = .InvalidMethodName
            case "InvalidPublicKey": self = .InvalidPublicKey
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid HostError: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid HostError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .BadUTF16:
            try container.encode("BadUTF16")
        case .BadUTF8:
            try container.encode("BadUTF8")
        case .GasExceeded:
            try container.encode("GasExceeded")
        case .GasLimitExceeded:
            try container.encode("GasLimitExceeded")
        case .BalanceExceeded:
            try container.encode("BalanceExceeded")
        case .EmptyMethodName:
            try container.encode("EmptyMethodName")
        case .GuestPanic(let value):
            try container.encode(["GuestPanic": AnyCodable(value)])
        case .IntegerOverflow:
            try container.encode("IntegerOverflow")
        case .InvalidPromiseIndex(let value):
            try container.encode(["InvalidPromiseIndex": AnyCodable(value)])
        case .CannotAppendActionToJointPromise:
            try container.encode("CannotAppendActionToJointPromise")
        case .CannotReturnJointPromise:
            try container.encode("CannotReturnJointPromise")
        case .InvalidPromiseResultIndex(let value):
            try container.encode(["InvalidPromiseResultIndex": AnyCodable(value)])
        case .InvalidRegisterId(let value):
            try container.encode(["InvalidRegisterId": AnyCodable(value)])
        case .IteratorWasInvalidated(let value):
            try container.encode(["IteratorWasInvalidated": AnyCodable(value)])
        case .MemoryAccessViolation:
            try container.encode("MemoryAccessViolation")
        case .InvalidReceiptIndex(let value):
            try container.encode(["InvalidReceiptIndex": AnyCodable(value)])
        case .InvalidIteratorIndex(let value):
            try container.encode(["InvalidIteratorIndex": AnyCodable(value)])
        case .InvalidAccountId:
            try container.encode("InvalidAccountId")
        case .InvalidMethodName:
            try container.encode("InvalidMethodName")
        case .InvalidPublicKey:
            try container.encode("InvalidPublicKey")
        case .ProhibitedInView(let value):
            try container.encode(["ProhibitedInView": AnyCodable(value)])
        case .NumberOfLogsExceeded(let value):
            try container.encode(["NumberOfLogsExceeded": AnyCodable(value)])
        case .KeyLengthExceeded(let value):
            try container.encode(["KeyLengthExceeded": AnyCodable(value)])
        case .ValueLengthExceeded(let value):
            try container.encode(["ValueLengthExceeded": AnyCodable(value)])
        case .TotalLogLengthExceeded(let value):
            try container.encode(["TotalLogLengthExceeded": AnyCodable(value)])
        case .NumberPromisesExceeded(let value):
            try container.encode(["NumberPromisesExceeded": AnyCodable(value)])
        case .NumberInputDataDependenciesExceeded(let value):
            try container.encode(["NumberInputDataDependenciesExceeded": AnyCodable(value)])
        case .ReturnedValueLengthExceeded(let value):
            try container.encode(["ReturnedValueLengthExceeded": AnyCodable(value)])
        case .ContractSizeExceeded(let value):
            try container.encode(["ContractSizeExceeded": AnyCodable(value)])
        case .Deprecated(let value):
            try container.encode(["Deprecated": AnyCodable(value)])
        case .ECRecoverError(let value):
            try container.encode(["ECRecoverError": AnyCodable(value)])
        case .AltBn128InvalidInput(let value):
            try container.encode(["AltBn128InvalidInput": AnyCodable(value)])
        case .Ed25519VerifyInvalidInput(let value):
            try container.encode(["Ed25519VerifyInvalidInput": AnyCodable(value)])
        }
    }
}

public enum InvalidAccessKeyError: Codable, Sendable {
    case AccessKeyNotFound(AnyCodable)
    case ReceiverMismatch(AnyCodable)
    case MethodNameMismatch(AnyCodable)
    case RequiresFullAccess
    case NotEnoughAllowance(AnyCodable)
    case DepositWithFunctionCall

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let accesskeynotfound = dict["AccessKeyNotFound"] {
                self = .AccessKeyNotFound(try accesskeynotfound.decode(AnyCodable.self))
            } else             if let receivermismatch = dict["ReceiverMismatch"] {
                self = .ReceiverMismatch(try receivermismatch.decode(AnyCodable.self))
            } else             if let methodnamemismatch = dict["MethodNameMismatch"] {
                self = .MethodNameMismatch(try methodnamemismatch.decode(AnyCodable.self))
            } else             if let notenoughallowance = dict["NotEnoughAllowance"] {
                self = .NotEnoughAllowance(try notenoughallowance.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid InvalidAccessKeyError")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "RequiresFullAccess": self = .RequiresFullAccess
            case "DepositWithFunctionCall": self = .DepositWithFunctionCall
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid InvalidAccessKeyError: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid InvalidAccessKeyError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .AccessKeyNotFound(let value):
            try container.encode(["AccessKeyNotFound": AnyCodable(value)])
        case .ReceiverMismatch(let value):
            try container.encode(["ReceiverMismatch": AnyCodable(value)])
        case .MethodNameMismatch(let value):
            try container.encode(["MethodNameMismatch": AnyCodable(value)])
        case .RequiresFullAccess:
            try container.encode("RequiresFullAccess")
        case .NotEnoughAllowance(let value):
            try container.encode(["NotEnoughAllowance": AnyCodable(value)])
        case .DepositWithFunctionCall:
            try container.encode("DepositWithFunctionCall")
        }
    }
}

/// An error happened during TX execution
public enum InvalidTxError: Codable, Sendable {
    case InvalidAccessKeyError(InvalidAccessKeyError)
    case InvalidSignerId(AnyCodable)
    case SignerDoesNotExist(AnyCodable)
    case InvalidNonce(AnyCodable)
    case NonceTooLarge(AnyCodable)
    case InvalidReceiverId(AnyCodable)
    case InvalidSignature
    case NotEnoughBalance(AnyCodable)
    case LackBalanceForState(AnyCodable)
    case CostOverflow
    case InvalidChain
    case Expired
    case ActionsValidation(ActionsValidationError)
    case TransactionSizeExceeded(AnyCodable)
    case InvalidTransactionVersion
    case StorageError(StorageError)
    case ShardCongested(AnyCodable)
    case ShardStuck(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let invalidaccesskeyerror = dict["InvalidAccessKeyError"] {
                self = .InvalidAccessKeyError(try invalidaccesskeyerror.decode(InvalidAccessKeyError.self))
            } else             if let invalidsignerid = dict["InvalidSignerId"] {
                self = .InvalidSignerId(try invalidsignerid.decode(AnyCodable.self))
            } else             if let signerdoesnotexist = dict["SignerDoesNotExist"] {
                self = .SignerDoesNotExist(try signerdoesnotexist.decode(AnyCodable.self))
            } else             if let invalidnonce = dict["InvalidNonce"] {
                self = .InvalidNonce(try invalidnonce.decode(AnyCodable.self))
            } else             if let noncetoolarge = dict["NonceTooLarge"] {
                self = .NonceTooLarge(try noncetoolarge.decode(AnyCodable.self))
            } else             if let invalidreceiverid = dict["InvalidReceiverId"] {
                self = .InvalidReceiverId(try invalidreceiverid.decode(AnyCodable.self))
            } else             if let notenoughbalance = dict["NotEnoughBalance"] {
                self = .NotEnoughBalance(try notenoughbalance.decode(AnyCodable.self))
            } else             if let lackbalanceforstate = dict["LackBalanceForState"] {
                self = .LackBalanceForState(try lackbalanceforstate.decode(AnyCodable.self))
            } else             if let actionsvalidation = dict["ActionsValidation"] {
                self = .ActionsValidation(try actionsvalidation.decode(ActionsValidationError.self))
            } else             if let transactionsizeexceeded = dict["TransactionSizeExceeded"] {
                self = .TransactionSizeExceeded(try transactionsizeexceeded.decode(AnyCodable.self))
            } else             if let storageerror = dict["StorageError"] {
                self = .StorageError(try storageerror.decode(StorageError.self))
            } else             if let shardcongested = dict["ShardCongested"] {
                self = .ShardCongested(try shardcongested.decode(AnyCodable.self))
            } else             if let shardstuck = dict["ShardStuck"] {
                self = .ShardStuck(try shardstuck.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid InvalidTxError")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "InvalidSignature": self = .InvalidSignature
            case "CostOverflow": self = .CostOverflow
            case "InvalidChain": self = .InvalidChain
            case "Expired": self = .Expired
            case "InvalidTransactionVersion": self = .InvalidTransactionVersion
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid InvalidTxError: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid InvalidTxError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .InvalidAccessKeyError(let value):
            try container.encode(["InvalidAccessKeyError": AnyCodable(value)])
        case .InvalidSignerId(let value):
            try container.encode(["InvalidSignerId": AnyCodable(value)])
        case .SignerDoesNotExist(let value):
            try container.encode(["SignerDoesNotExist": AnyCodable(value)])
        case .InvalidNonce(let value):
            try container.encode(["InvalidNonce": AnyCodable(value)])
        case .NonceTooLarge(let value):
            try container.encode(["NonceTooLarge": AnyCodable(value)])
        case .InvalidReceiverId(let value):
            try container.encode(["InvalidReceiverId": AnyCodable(value)])
        case .InvalidSignature:
            try container.encode("InvalidSignature")
        case .NotEnoughBalance(let value):
            try container.encode(["NotEnoughBalance": AnyCodable(value)])
        case .LackBalanceForState(let value):
            try container.encode(["LackBalanceForState": AnyCodable(value)])
        case .CostOverflow:
            try container.encode("CostOverflow")
        case .InvalidChain:
            try container.encode("InvalidChain")
        case .Expired:
            try container.encode("Expired")
        case .ActionsValidation(let value):
            try container.encode(["ActionsValidation": AnyCodable(value)])
        case .TransactionSizeExceeded(let value):
            try container.encode(["TransactionSizeExceeded": AnyCodable(value)])
        case .InvalidTransactionVersion:
            try container.encode("InvalidTransactionVersion")
        case .StorageError(let value):
            try container.encode(["StorageError": AnyCodable(value)])
        case .ShardCongested(let value):
            try container.encode(["ShardCongested": AnyCodable(value)])
        case .ShardStuck(let value):
            try container.encode(["ShardStuck": AnyCodable(value)])
        }
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_changes: Codable, Sendable {
    public let jsonrpc: String
    public let params: RpcStateChangesInBlockByTypeRequest
    public let id: String
    public let method: String

    public init(jsonrpc: String, params: RpcStateChangesInBlockByTypeRequest, id: String, method: String) {
        self.jsonrpc = jsonrpc
        self.params = params
        self.id = id
        self.method = method
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_changes_in_block: Codable, Sendable {
    public let jsonrpc: String
    public let params: RpcStateChangesInBlockRequest
    public let id: String
    public let method: String

    public init(jsonrpc: String, params: RpcStateChangesInBlockRequest, id: String, method: String) {
        self.jsonrpc = jsonrpc
        self.params = params
        self.id = id
        self.method = method
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_congestion_level: Codable, Sendable {
    public let jsonrpc: String
    public let params: RpcCongestionLevelRequest
    public let id: String
    public let method: String

    public init(jsonrpc: String, params: RpcCongestionLevelRequest, id: String, method: String) {
        self.jsonrpc = jsonrpc
        self.params = params
        self.id = id
        self.method = method
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_genesis_config: Codable, Sendable {
    public let jsonrpc: String
    public let method: String
    public let params: GenesisConfigRequest
    public let id: String

    public init(jsonrpc: String, method: String, params: GenesisConfigRequest, id: String) {
        self.jsonrpc = jsonrpc
        self.method = method
        self.params = params
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_light_client_block_proof: Codable, Sendable {
    public let method: String
    public let params: RpcLightClientBlockProofRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcLightClientBlockProofRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_light_client_proof: Codable, Sendable {
    public let method: String
    public let params: RpcLightClientExecutionProofRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcLightClientExecutionProofRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_maintenance_windows: Codable, Sendable {
    public let method: String
    public let params: RpcMaintenanceWindowsRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcMaintenanceWindowsRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_protocol_config: Codable, Sendable {
    public let method: String
    public let params: RpcProtocolConfigRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcProtocolConfigRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_receipt: Codable, Sendable {
    public let method: String
    public let params: RpcReceiptRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcReceiptRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_split_storage_info: Codable, Sendable {
    public let method: String
    public let params: RpcSplitStorageInfoRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcSplitStorageInfoRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_tx_status: Codable, Sendable {
    public let method: String
    public let params: RpcTransactionStatusRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcTransactionStatusRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_EXPERIMENTAL_validators_ordered: Codable, Sendable {
    public let method: String
    public let params: RpcValidatorsOrderedRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcValidatorsOrderedRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_block: Codable, Sendable {
    public let method: String
    public let params: RpcBlockRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcBlockRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_block_effects: Codable, Sendable {
    public let method: String
    public let params: RpcStateChangesInBlockRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcStateChangesInBlockRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_broadcast_tx_async: Codable, Sendable {
    public let method: String
    public let params: RpcSendTransactionRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcSendTransactionRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_broadcast_tx_commit: Codable, Sendable {
    public let method: String
    public let params: RpcSendTransactionRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcSendTransactionRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_changes: Codable, Sendable {
    public let method: String
    public let params: RpcStateChangesInBlockByTypeRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcStateChangesInBlockByTypeRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_chunk: Codable, Sendable {
    public let method: String
    public let params: RpcChunkRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcChunkRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_client_config: Codable, Sendable {
    public let method: String
    public let params: RpcClientConfigRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcClientConfigRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_gas_price: Codable, Sendable {
    public let method: String
    public let params: RpcGasPriceRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcGasPriceRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_genesis_config: Codable, Sendable {
    public let method: String
    public let params: GenesisConfigRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: GenesisConfigRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_health: Codable, Sendable {
    public let method: String
    public let params: RpcHealthRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcHealthRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_light_client_proof: Codable, Sendable {
    public let method: String
    public let params: RpcLightClientExecutionProofRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcLightClientExecutionProofRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_maintenance_windows: Codable, Sendable {
    public let method: String
    public let params: RpcMaintenanceWindowsRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcMaintenanceWindowsRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_network_info: Codable, Sendable {
    public let method: String
    public let params: RpcNetworkInfoRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcNetworkInfoRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_next_light_client_block: Codable, Sendable {
    public let method: String
    public let params: RpcLightClientNextBlockRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcLightClientNextBlockRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_query: Codable, Sendable {
    public let method: String
    public let params: RpcQueryRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcQueryRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_send_tx: Codable, Sendable {
    public let method: String
    public let params: RpcSendTransactionRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcSendTransactionRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_status: Codable, Sendable {
    public let method: String
    public let params: RpcStatusRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcStatusRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_tx: Codable, Sendable {
    public let method: String
    public let params: RpcTransactionStatusRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcTransactionStatusRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public struct JsonRpcRequest_for_validators: Codable, Sendable {
    public let method: String
    public let params: RpcValidatorRequest
    public let jsonrpc: String
    public let id: String

    public init(method: String, params: RpcValidatorRequest, jsonrpc: String, id: String) {
        self.method = method
        self.params = params
        self.jsonrpc = jsonrpc
        self.id = id
    }
}

public enum JsonRpcResponse_for_Array_of_Range_of_uint64_and_RpcError: Codable, Sendable {
    case result([AnyCodable])
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode([AnyCodable].self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_Array_of_Range_of_uint64_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_Array_of_Range_of_uint64_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_Array_of_ValidatorStakeView_and_RpcError: Codable, Sendable {
    case result([AnyCodable])
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode([AnyCodable].self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_Array_of_ValidatorStakeView_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_Array_of_ValidatorStakeView_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_CryptoHash_and_RpcError: Codable, Sendable {
    case result(CryptoHash)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(CryptoHash.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_CryptoHash_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_CryptoHash_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_GenesisConfig_and_RpcError: Codable, Sendable {
    case result(GenesisConfig)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(GenesisConfig.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_GenesisConfig_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_GenesisConfig_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_Nullable_RpcHealthResponse_and_RpcError: Codable, Sendable {
    case result(AnyCodable)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(AnyCodable.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_Nullable_RpcHealthResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_Nullable_RpcHealthResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcBlockResponse_and_RpcError: Codable, Sendable {
    case result(RpcBlockResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcBlockResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcBlockResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcBlockResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcChunkResponse_and_RpcError: Codable, Sendable {
    case result(RpcChunkResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcChunkResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcChunkResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcChunkResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcClientConfigResponse_and_RpcError: Codable, Sendable {
    case result(RpcClientConfigResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcClientConfigResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcClientConfigResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcClientConfigResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcCongestionLevelResponse_and_RpcError: Codable, Sendable {
    case result(RpcCongestionLevelResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcCongestionLevelResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcCongestionLevelResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcCongestionLevelResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcGasPriceResponse_and_RpcError: Codable, Sendable {
    case result(RpcGasPriceResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcGasPriceResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcGasPriceResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcGasPriceResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcLightClientBlockProofResponse_and_RpcError: Codable, Sendable {
    case result(RpcLightClientBlockProofResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcLightClientBlockProofResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcLightClientBlockProofResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcLightClientBlockProofResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcLightClientExecutionProofResponse_and_RpcError: Codable, Sendable {
    case result(RpcLightClientExecutionProofResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcLightClientExecutionProofResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcLightClientExecutionProofResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcLightClientExecutionProofResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcLightClientNextBlockResponse_and_RpcError: Codable, Sendable {
    case result(RpcLightClientNextBlockResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcLightClientNextBlockResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcLightClientNextBlockResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcLightClientNextBlockResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcNetworkInfoResponse_and_RpcError: Codable, Sendable {
    case result(RpcNetworkInfoResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcNetworkInfoResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcNetworkInfoResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcNetworkInfoResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcProtocolConfigResponse_and_RpcError: Codable, Sendable {
    case result(RpcProtocolConfigResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcProtocolConfigResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcProtocolConfigResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcProtocolConfigResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcQueryResponse_and_RpcError: Codable, Sendable {
    case result(RpcQueryResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcQueryResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcQueryResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcQueryResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcReceiptResponse_and_RpcError: Codable, Sendable {
    case result(RpcReceiptResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcReceiptResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcReceiptResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcReceiptResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcSplitStorageInfoResponse_and_RpcError: Codable, Sendable {
    case result(RpcSplitStorageInfoResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcSplitStorageInfoResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcSplitStorageInfoResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcSplitStorageInfoResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcStateChangesInBlockByTypeResponse_and_RpcError: Codable, Sendable {
    case result(RpcStateChangesInBlockByTypeResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcStateChangesInBlockByTypeResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcStateChangesInBlockByTypeResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcStateChangesInBlockByTypeResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcStateChangesInBlockResponse_and_RpcError: Codable, Sendable {
    case result(RpcStateChangesInBlockResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcStateChangesInBlockResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcStateChangesInBlockResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcStateChangesInBlockResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcStatusResponse_and_RpcError: Codable, Sendable {
    case result(RpcStatusResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcStatusResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcStatusResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcStatusResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcTransactionResponse_and_RpcError: Codable, Sendable {
    case result(RpcTransactionResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcTransactionResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcTransactionResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcTransactionResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

public enum JsonRpcResponse_for_RpcValidatorResponse_and_RpcError: Codable, Sendable {
    case result(RpcValidatorResponse)
    case error(RpcError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let result = dict["result"] {
                self = .result(try result.decode(RpcValidatorResponse.self))
            } else             if let error = dict["error"] {
                self = .error(try error.decode(RpcError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcValidatorResponse_and_RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JsonRpcResponse_for_RpcValidatorResponse_and_RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .result(let value):
            try container.encode(["result": AnyCodable(value)])
        case .error(let value):
            try container.encode(["error": AnyCodable(value)])
        }
    }
}

/// Information about a Producer: its account name, peer_id and a list of connected peers that
the node can use to send message for this producer.
public struct KnownProducerView: Codable, Sendable {
    public let next_hops: [AnyCodable]?
    public let peer_id: PublicKey
    public let account_id: AccountId

    public init(next_hops: [AnyCodable]? = nil, peer_id: PublicKey, account_id: AccountId) {
        self.next_hops = next_hops
        self.peer_id = peer_id
        self.account_id = account_id
    }
}

public struct LightClientBlockLiteView: Codable, Sendable {
    public let inner_lite: BlockHeaderInnerLiteView
    public let prev_block_hash: CryptoHash
    public let inner_rest_hash: CryptoHash

    public init(inner_lite: BlockHeaderInnerLiteView, prev_block_hash: CryptoHash, inner_rest_hash: CryptoHash) {
        self.inner_lite = inner_lite
        self.prev_block_hash = prev_block_hash
        self.inner_rest_hash = inner_rest_hash
    }
}

/// Describes limits for VM and Runtime.
TODO #4139: consider switching to strongly-typed wrappers instead of raw quantities
public struct LimitConfig: Codable, Sendable {
    public let max_total_prepaid_gas: AnyCodable
    public let max_register_size: UInt64
    public let yield_timeout_length_in_blocks: UInt64
    public let max_number_input_data_dependencies: UInt64
    public let max_gas_burnt: AnyCodable
    public let max_locals_per_contract: UInt64?
    public let max_number_logs: UInt64
    public let account_id_validity_rules_version: AnyCodable?
    public let max_contract_size: UInt64
    public let max_transaction_size: UInt64
    public let max_stack_height: Int
    public let per_receipt_storage_proof_size_limit: Int
    public let max_receipt_size: UInt64
    public let max_total_log_length: UInt64
    public let max_functions_number_per_contract: UInt64?
    public let max_yield_payload_size: UInt64
    public let max_length_returned_data: UInt64
    public let initial_memory_pages: Int
    public let max_arguments_length: UInt64
    public let registers_memory_limit: UInt64
    public let max_tables_per_contract: Int?
    public let max_length_storage_key: UInt64
    public let max_number_registers: UInt64
    public let max_elements_per_contract_table: Int?
    public let max_length_storage_value: UInt64
    public let max_memory_pages: Int
    public let max_length_method_name: UInt64
    public let max_promises_per_function_call_action: UInt64
    public let max_number_bytes_method_names: UInt64
    public let max_actions_per_receipt: UInt64

    public init(max_total_prepaid_gas: AnyCodable, max_register_size: UInt64, yield_timeout_length_in_blocks: UInt64, max_number_input_data_dependencies: UInt64, max_gas_burnt: AnyCodable, max_locals_per_contract: UInt64? = nil, max_number_logs: UInt64, account_id_validity_rules_version: AnyCodable? = nil, max_contract_size: UInt64, max_transaction_size: UInt64, max_stack_height: Int, per_receipt_storage_proof_size_limit: Int, max_receipt_size: UInt64, max_total_log_length: UInt64, max_functions_number_per_contract: UInt64? = nil, max_yield_payload_size: UInt64, max_length_returned_data: UInt64, initial_memory_pages: Int, max_arguments_length: UInt64, registers_memory_limit: UInt64, max_tables_per_contract: Int? = nil, max_length_storage_key: UInt64, max_number_registers: UInt64, max_elements_per_contract_table: Int? = nil, max_length_storage_value: UInt64, max_memory_pages: Int, max_length_method_name: UInt64, max_promises_per_function_call_action: UInt64, max_number_bytes_method_names: UInt64, max_actions_per_receipt: UInt64) {
        self.max_total_prepaid_gas = max_total_prepaid_gas
        self.max_register_size = max_register_size
        self.yield_timeout_length_in_blocks = yield_timeout_length_in_blocks
        self.max_number_input_data_dependencies = max_number_input_data_dependencies
        self.max_gas_burnt = max_gas_burnt
        self.max_locals_per_contract = max_locals_per_contract
        self.max_number_logs = max_number_logs
        self.account_id_validity_rules_version = account_id_validity_rules_version
        self.max_contract_size = max_contract_size
        self.max_transaction_size = max_transaction_size
        self.max_stack_height = max_stack_height
        self.per_receipt_storage_proof_size_limit = per_receipt_storage_proof_size_limit
        self.max_receipt_size = max_receipt_size
        self.max_total_log_length = max_total_log_length
        self.max_functions_number_per_contract = max_functions_number_per_contract
        self.max_yield_payload_size = max_yield_payload_size
        self.max_length_returned_data = max_length_returned_data
        self.initial_memory_pages = initial_memory_pages
        self.max_arguments_length = max_arguments_length
        self.registers_memory_limit = registers_memory_limit
        self.max_tables_per_contract = max_tables_per_contract
        self.max_length_storage_key = max_length_storage_key
        self.max_number_registers = max_number_registers
        self.max_elements_per_contract_table = max_elements_per_contract_table
        self.max_length_storage_value = max_length_storage_value
        self.max_memory_pages = max_memory_pages
        self.max_length_method_name = max_length_method_name
        self.max_promises_per_function_call_action = max_promises_per_function_call_action
        self.max_number_bytes_method_names = max_number_bytes_method_names
        self.max_actions_per_receipt = max_actions_per_receipt
    }
}

public enum LogSummaryStyle: Codable, Sendable {
    case plain
    case colored
}

public struct MerklePathItem: Codable, Sendable {
    public let hash: CryptoHash
    public let direction: Direction

    public init(hash: CryptoHash, direction: Direction) {
        self.hash = hash
        self.direction = direction
    }
}

public enum MethodResolveError: Codable, Sendable {
    case MethodEmptyName
    case MethodNotFound
    case MethodInvalidSignature
}

public struct MissingTrieValue: Codable, Sendable {
    public let hash: CryptoHash
    public let context: MissingTrieValueContext

    public init(hash: CryptoHash, context: MissingTrieValueContext) {
        self.hash = hash
        self.context = context
    }
}

/// Contexts in which `StorageError::MissingTrieValue` error might occur.
public enum MissingTrieValueContext: Codable, Sendable {
    case TrieIterator
    case TriePrefetchingStorage
    case TrieMemoryPartialStorage
    case TrieStorage
}

public typealias MutableConfigValue = String

public typealias NearGas = Int

public struct NetworkInfoView: Codable, Sendable {
    public let tier1_connections: [AnyCodable]
    public let connected_peers: [AnyCodable]
    public let known_producers: [AnyCodable]
    public let peer_max_count: Int
    public let tier1_accounts_keys: [AnyCodable]
    public let tier1_accounts_data: [AnyCodable]
    public let num_connected_peers: Int

    public init(tier1_connections: [AnyCodable], connected_peers: [AnyCodable], known_producers: [AnyCodable], peer_max_count: Int, tier1_accounts_keys: [AnyCodable], tier1_accounts_data: [AnyCodable], num_connected_peers: Int) {
        self.tier1_connections = tier1_connections
        self.connected_peers = connected_peers
        self.known_producers = known_producers
        self.peer_max_count = peer_max_count
        self.tier1_accounts_keys = tier1_accounts_keys
        self.tier1_accounts_data = tier1_accounts_data
        self.num_connected_peers = num_connected_peers
    }
}

public struct NextEpochValidatorInfo: Codable, Sendable {
    public let account_id: AccountId
    public let public_key: PublicKey
    public let stake: String
    public let shards: [AnyCodable]

    public init(account_id: AccountId, public_key: PublicKey, stake: String, shards: [AnyCodable]) {
        self.account_id = account_id
        self.public_key = public_key
        self.stake = stake
        self.shards = shards
    }
}

/// An Action that can be included in a transaction or receipt, excluding delegate actions. This type represents all possible action types except DelegateAction to prevent infinite recursion in meta-transactions.
public enum NonDelegateAction: Codable, Sendable {
    case CreateAccount(CreateAccountAction)
    case DeployContract(DeployContractAction)
    case FunctionCall(FunctionCallAction)
    case Transfer(TransferAction)
    case Stake(StakeAction)
    case AddKey(AddKeyAction)
    case DeleteKey(DeleteKeyAction)
    case DeleteAccount(DeleteAccountAction)
    case DeployGlobalContract(DeployGlobalContractAction)
    case UseGlobalContract(UseGlobalContractAction)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let createaccount = dict["CreateAccount"] {
                self = .CreateAccount(try createaccount.decode(CreateAccountAction.self))
            } else             if let deploycontract = dict["DeployContract"] {
                self = .DeployContract(try deploycontract.decode(DeployContractAction.self))
            } else             if let functioncall = dict["FunctionCall"] {
                self = .FunctionCall(try functioncall.decode(FunctionCallAction.self))
            } else             if let transfer = dict["Transfer"] {
                self = .Transfer(try transfer.decode(TransferAction.self))
            } else             if let stake = dict["Stake"] {
                self = .Stake(try stake.decode(StakeAction.self))
            } else             if let addkey = dict["AddKey"] {
                self = .AddKey(try addkey.decode(AddKeyAction.self))
            } else             if let deletekey = dict["DeleteKey"] {
                self = .DeleteKey(try deletekey.decode(DeleteKeyAction.self))
            } else             if let deleteaccount = dict["DeleteAccount"] {
                self = .DeleteAccount(try deleteaccount.decode(DeleteAccountAction.self))
            } else             if let deployglobalcontract = dict["DeployGlobalContract"] {
                self = .DeployGlobalContract(try deployglobalcontract.decode(DeployGlobalContractAction.self))
            } else             if let useglobalcontract = dict["UseGlobalContract"] {
                self = .UseGlobalContract(try useglobalcontract.decode(UseGlobalContractAction.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid NonDelegateAction")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid NonDelegateAction")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .CreateAccount(let value):
            try container.encode(["CreateAccount": AnyCodable(value)])
        case .DeployContract(let value):
            try container.encode(["DeployContract": AnyCodable(value)])
        case .FunctionCall(let value):
            try container.encode(["FunctionCall": AnyCodable(value)])
        case .Transfer(let value):
            try container.encode(["Transfer": AnyCodable(value)])
        case .Stake(let value):
            try container.encode(["Stake": AnyCodable(value)])
        case .AddKey(let value):
            try container.encode(["AddKey": AnyCodable(value)])
        case .DeleteKey(let value):
            try container.encode(["DeleteKey": AnyCodable(value)])
        case .DeleteAccount(let value):
            try container.encode(["DeleteAccount": AnyCodable(value)])
        case .DeployGlobalContract(let value):
            try container.encode(["DeployGlobalContract": AnyCodable(value)])
        case .UseGlobalContract(let value):
            try container.encode(["UseGlobalContract": AnyCodable(value)])
        }
    }
}

/// Peer id is the public key.
public struct PeerId: Codable, Sendable {
}

public struct PeerInfoView: Codable, Sendable {
    public let last_time_received_message_millis: UInt64
    public let archival: Bool
    public let tracked_shards: [AnyCodable]
    public let addr: String
    public let last_time_peer_requested_millis: UInt64
    public let account_id: AnyCodable?
    public let height: UInt64?
    public let sent_bytes_per_sec: UInt64
    public let is_outbound_peer: Bool
    public let nonce: UInt64
    public let connection_established_time_millis: UInt64
    public let peer_id: PublicKey
    public let is_highest_block_invalid: Bool
    public let received_bytes_per_sec: UInt64
    public let block_hash: AnyCodable?

    public init(last_time_received_message_millis: UInt64, archival: Bool, tracked_shards: [AnyCodable], addr: String, last_time_peer_requested_millis: UInt64, account_id: AnyCodable? = nil, height: UInt64? = nil, sent_bytes_per_sec: UInt64, is_outbound_peer: Bool, nonce: UInt64, connection_established_time_millis: UInt64, peer_id: PublicKey, is_highest_block_invalid: Bool, received_bytes_per_sec: UInt64, block_hash: AnyCodable? = nil) {
        self.last_time_received_message_millis = last_time_received_message_millis
        self.archival = archival
        self.tracked_shards = tracked_shards
        self.addr = addr
        self.last_time_peer_requested_millis = last_time_peer_requested_millis
        self.account_id = account_id
        self.height = height
        self.sent_bytes_per_sec = sent_bytes_per_sec
        self.is_outbound_peer = is_outbound_peer
        self.nonce = nonce
        self.connection_established_time_millis = connection_established_time_millis
        self.peer_id = peer_id
        self.is_highest_block_invalid = is_highest_block_invalid
        self.received_bytes_per_sec = received_bytes_per_sec
        self.block_hash = block_hash
    }
}

/// Error that can occur while preparing or executing Wasm smart-contract.
public enum PrepareError: Codable, Sendable {
    case Serialization
    case Deserialization
    case InternalMemoryDeclared
    case GasInstrumentation
    case StackHeightInstrumentation
    case Instantiate
    case Memory
    case TooManyFunctions
    case TooManyLocals
    case TooManyTables
    case TooManyTableElements
}

/// Configures whether the node checks the next or the next next epoch for network version compatibility.
public enum ProtocolVersionCheckConfig: Codable, Sendable {
    case Next
    case NextNext
}

public typealias PublicKey = String

public struct Range_of_uint64: Codable, Sendable {
    public let start: UInt64
    public let end: UInt64

    public init(start: UInt64, end: UInt64) {
        self.start = start
        self.end = end
    }
}

public enum ReceiptEnumView: Codable, Sendable {
    case Action(AnyCodable)
    case Data(AnyCodable)
    case GlobalContractDistribution(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let action = dict["Action"] {
                self = .Action(try action.decode(AnyCodable.self))
            } else             if let data = dict["Data"] {
                self = .Data(try data.decode(AnyCodable.self))
            } else             if let globalcontractdistribution = dict["GlobalContractDistribution"] {
                self = .GlobalContractDistribution(try globalcontractdistribution.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ReceiptEnumView")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ReceiptEnumView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .Action(let value):
            try container.encode(["Action": AnyCodable(value)])
        case .Data(let value):
            try container.encode(["Data": AnyCodable(value)])
        case .GlobalContractDistribution(let value):
            try container.encode(["GlobalContractDistribution": AnyCodable(value)])
        }
    }
}

/// Describes the error for validating a receipt.
public enum ReceiptValidationError: Codable, Sendable {
    case InvalidPredecessorId(AnyCodable)
    case InvalidReceiverId(AnyCodable)
    case InvalidSignerId(AnyCodable)
    case InvalidDataReceiverId(AnyCodable)
    case ReturnedValueLengthExceeded(AnyCodable)
    case NumberInputDataDependenciesExceeded(AnyCodable)
    case ActionsValidation(ActionsValidationError)
    case ReceiptSizeExceeded(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let invalidpredecessorid = dict["InvalidPredecessorId"] {
                self = .InvalidPredecessorId(try invalidpredecessorid.decode(AnyCodable.self))
            } else             if let invalidreceiverid = dict["InvalidReceiverId"] {
                self = .InvalidReceiverId(try invalidreceiverid.decode(AnyCodable.self))
            } else             if let invalidsignerid = dict["InvalidSignerId"] {
                self = .InvalidSignerId(try invalidsignerid.decode(AnyCodable.self))
            } else             if let invaliddatareceiverid = dict["InvalidDataReceiverId"] {
                self = .InvalidDataReceiverId(try invaliddatareceiverid.decode(AnyCodable.self))
            } else             if let returnedvaluelengthexceeded = dict["ReturnedValueLengthExceeded"] {
                self = .ReturnedValueLengthExceeded(try returnedvaluelengthexceeded.decode(AnyCodable.self))
            } else             if let numberinputdatadependenciesexceeded = dict["NumberInputDataDependenciesExceeded"] {
                self = .NumberInputDataDependenciesExceeded(try numberinputdatadependenciesexceeded.decode(AnyCodable.self))
            } else             if let actionsvalidation = dict["ActionsValidation"] {
                self = .ActionsValidation(try actionsvalidation.decode(ActionsValidationError.self))
            } else             if let receiptsizeexceeded = dict["ReceiptSizeExceeded"] {
                self = .ReceiptSizeExceeded(try receiptsizeexceeded.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ReceiptValidationError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ReceiptValidationError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .InvalidPredecessorId(let value):
            try container.encode(["InvalidPredecessorId": AnyCodable(value)])
        case .InvalidReceiverId(let value):
            try container.encode(["InvalidReceiverId": AnyCodable(value)])
        case .InvalidSignerId(let value):
            try container.encode(["InvalidSignerId": AnyCodable(value)])
        case .InvalidDataReceiverId(let value):
            try container.encode(["InvalidDataReceiverId": AnyCodable(value)])
        case .ReturnedValueLengthExceeded(let value):
            try container.encode(["ReturnedValueLengthExceeded": AnyCodable(value)])
        case .NumberInputDataDependenciesExceeded(let value):
            try container.encode(["NumberInputDataDependenciesExceeded": AnyCodable(value)])
        case .ActionsValidation(let value):
            try container.encode(["ActionsValidation": AnyCodable(value)])
        case .ReceiptSizeExceeded(let value):
            try container.encode(["ReceiptSizeExceeded": AnyCodable(value)])
        }
    }
}

public struct ReceiptView: Codable, Sendable {
    public let receipt_id: CryptoHash
    public let priority: UInt64?
    public let predecessor_id: AccountId
    public let receiver_id: AccountId
    public let receipt: ReceiptEnumView

    public init(receipt_id: CryptoHash, priority: UInt64? = nil, predecessor_id: AccountId, receiver_id: AccountId, receipt: ReceiptEnumView) {
        self.receipt_id = receipt_id
        self.priority = priority
        self.predecessor_id = predecessor_id
        self.receiver_id = receiver_id
        self.receipt = receipt
    }
}

public enum RpcBlockRequest: Codable, Sendable {
    case block_id(BlockId)
    case finality(Finality)
    case sync_checkpoint(SyncCheckpoint)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let block_id = dict["block_id"] {
                self = .block_id(try block_id.decode(BlockId.self))
            } else             if let finality = dict["finality"] {
                self = .finality(try finality.decode(Finality.self))
            } else             if let sync_checkpoint = dict["sync_checkpoint"] {
                self = .sync_checkpoint(try sync_checkpoint.decode(SyncCheckpoint.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcBlockRequest")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcBlockRequest")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .block_id(let value):
            try container.encode(["block_id": AnyCodable(value)])
        case .finality(let value):
            try container.encode(["finality": AnyCodable(value)])
        case .sync_checkpoint(let value):
            try container.encode(["sync_checkpoint": AnyCodable(value)])
        }
    }
}

public struct RpcBlockResponse: Codable, Sendable {
    public let author: AnyCodable
    public let chunks: [AnyCodable]
    public let header: BlockHeaderView

    public init(author: AnyCodable, chunks: [AnyCodable], header: BlockHeaderView) {
        self.author = author
        self.chunks = chunks
        self.header = header
    }
}

public typealias RpcChunkRequest = AnyCodable

public struct RpcChunkResponse: Codable, Sendable {
    public let author: AccountId
    public let transactions: [AnyCodable]
    public let header: ChunkHeaderView
    public let receipts: [AnyCodable]

    public init(author: AccountId, transactions: [AnyCodable], header: ChunkHeaderView, receipts: [AnyCodable]) {
        self.author = author
        self.transactions = transactions
        self.header = header
        self.receipts = receipts
    }
}

public enum RpcClientConfigRequest: Codable, Sendable {
}

/// ClientConfig where some fields can be updated at runtime.
public struct RpcClientConfigResponse: Codable, Sendable {
    public let doomslug_step_period: [UInt64]
    public let max_gas_burnt_view: AnyCodable?
    public let view_client_threads: Int
    public let chunk_request_retry_period: [UInt64]
    public let state_request_server_threads: Int
    public let version: AnyCodable
    public let state_sync_enabled: Bool
    public let produce_chunk_add_transactions_time_limit: String
    public let catchup_step_period: [UInt64]
    public let log_summary_period: [UInt64]
    public let client_background_migration_threads: Int
    public let header_sync_expected_height_per_second: UInt64
    public let orphan_state_witness_pool_size: Int
    public let enable_multiline_logging: Bool
    public let transaction_request_handler_threads: Int
    public let state_sync_external_timeout: [UInt64]
    public let cloud_archival_reader: AnyCodable?
    public let num_block_producer_seats: UInt64
    public let chunk_validation_threads: Int
    public let chunk_wait_mult: [Int]
    public let produce_empty_blocks: Bool
    public let chunk_distribution_network: AnyCodable?
    public let transaction_pool_size_limit: UInt64?
    public let epoch_sync: AnyCodable
    public let state_sync_p2p_timeout: [UInt64]
    public let state_request_throttle_period: [UInt64]
    public let archive: Bool
    public let resharding_config: MutableConfigValue
    public let block_fetch_horizon: UInt64
    public let gc: AnyCodable
    public let enable_statistics_export: Bool
    public let chain_id: String
    public let sync_step_period: [UInt64]
    public let save_latest_witnesses: Bool
    public let ttl_account_id_router: [UInt64]
    public let sync_check_period: [UInt64]
    public let skip_sync_wait: Bool
    public let state_sync_retry_backoff: [UInt64]
    public let trie_viewer_state_size_limit: UInt64?
    public let block_header_fetch_horizon: UInt64
    public let header_sync_progress_timeout: [UInt64]
    public let state_sync: AnyCodable
    public let state_requests_per_throttle_period: Int
    public let save_invalid_witnesses: Bool
    public let min_block_production_delay: [UInt64]
    public let state_sync_external_backoff: [UInt64]
    public let sync_height_threshold: UInt64
    public let expected_shutdown: AnyCodable
    public let header_sync_initial_timeout: [UInt64]
    public let header_sync_stall_ban_timeout: [UInt64]
    public let epoch_length: UInt64
    public let block_production_tracking_delay: [UInt64]
    public let sync_max_block_requests: Int
    public let rpc_addr: String?
    public let tracked_shards_config: TrackedShardsConfig
    public let min_num_peers: Int
    public let orphan_state_witness_max_size: UInt64
    public let cloud_archival_writer: AnyCodable?
    public let max_block_wait_delay: [UInt64]
    public let save_tx_outcomes: Bool
    public let tx_routing_height_horizon: UInt64
    public let max_block_production_delay: [UInt64]
    public let log_summary_style: AnyCodable
    public let protocol_version_check: AnyCodable
    public let save_trie_changes: Bool

    public init(doomslug_step_period: [UInt64], max_gas_burnt_view: AnyCodable? = nil, view_client_threads: Int, chunk_request_retry_period: [UInt64], state_request_server_threads: Int, version: AnyCodable, state_sync_enabled: Bool, produce_chunk_add_transactions_time_limit: String, catchup_step_period: [UInt64], log_summary_period: [UInt64], client_background_migration_threads: Int, header_sync_expected_height_per_second: UInt64, orphan_state_witness_pool_size: Int, enable_multiline_logging: Bool, transaction_request_handler_threads: Int, state_sync_external_timeout: [UInt64], cloud_archival_reader: AnyCodable? = nil, num_block_producer_seats: UInt64, chunk_validation_threads: Int, chunk_wait_mult: [Int], produce_empty_blocks: Bool, chunk_distribution_network: AnyCodable? = nil, transaction_pool_size_limit: UInt64? = nil, epoch_sync: AnyCodable, state_sync_p2p_timeout: [UInt64], state_request_throttle_period: [UInt64], archive: Bool, resharding_config: MutableConfigValue, block_fetch_horizon: UInt64, gc: AnyCodable, enable_statistics_export: Bool, chain_id: String, sync_step_period: [UInt64], save_latest_witnesses: Bool, ttl_account_id_router: [UInt64], sync_check_period: [UInt64], skip_sync_wait: Bool, state_sync_retry_backoff: [UInt64], trie_viewer_state_size_limit: UInt64? = nil, block_header_fetch_horizon: UInt64, header_sync_progress_timeout: [UInt64], state_sync: AnyCodable, state_requests_per_throttle_period: Int, save_invalid_witnesses: Bool, min_block_production_delay: [UInt64], state_sync_external_backoff: [UInt64], sync_height_threshold: UInt64, expected_shutdown: AnyCodable, header_sync_initial_timeout: [UInt64], header_sync_stall_ban_timeout: [UInt64], epoch_length: UInt64, block_production_tracking_delay: [UInt64], sync_max_block_requests: Int, rpc_addr: String? = nil, tracked_shards_config: TrackedShardsConfig, min_num_peers: Int, orphan_state_witness_max_size: UInt64, cloud_archival_writer: AnyCodable? = nil, max_block_wait_delay: [UInt64], save_tx_outcomes: Bool, tx_routing_height_horizon: UInt64, max_block_production_delay: [UInt64], log_summary_style: AnyCodable, protocol_version_check: AnyCodable, save_trie_changes: Bool) {
        self.doomslug_step_period = doomslug_step_period
        self.max_gas_burnt_view = max_gas_burnt_view
        self.view_client_threads = view_client_threads
        self.chunk_request_retry_period = chunk_request_retry_period
        self.state_request_server_threads = state_request_server_threads
        self.version = version
        self.state_sync_enabled = state_sync_enabled
        self.produce_chunk_add_transactions_time_limit = produce_chunk_add_transactions_time_limit
        self.catchup_step_period = catchup_step_period
        self.log_summary_period = log_summary_period
        self.client_background_migration_threads = client_background_migration_threads
        self.header_sync_expected_height_per_second = header_sync_expected_height_per_second
        self.orphan_state_witness_pool_size = orphan_state_witness_pool_size
        self.enable_multiline_logging = enable_multiline_logging
        self.transaction_request_handler_threads = transaction_request_handler_threads
        self.state_sync_external_timeout = state_sync_external_timeout
        self.cloud_archival_reader = cloud_archival_reader
        self.num_block_producer_seats = num_block_producer_seats
        self.chunk_validation_threads = chunk_validation_threads
        self.chunk_wait_mult = chunk_wait_mult
        self.produce_empty_blocks = produce_empty_blocks
        self.chunk_distribution_network = chunk_distribution_network
        self.transaction_pool_size_limit = transaction_pool_size_limit
        self.epoch_sync = epoch_sync
        self.state_sync_p2p_timeout = state_sync_p2p_timeout
        self.state_request_throttle_period = state_request_throttle_period
        self.archive = archive
        self.resharding_config = resharding_config
        self.block_fetch_horizon = block_fetch_horizon
        self.gc = gc
        self.enable_statistics_export = enable_statistics_export
        self.chain_id = chain_id
        self.sync_step_period = sync_step_period
        self.save_latest_witnesses = save_latest_witnesses
        self.ttl_account_id_router = ttl_account_id_router
        self.sync_check_period = sync_check_period
        self.skip_sync_wait = skip_sync_wait
        self.state_sync_retry_backoff = state_sync_retry_backoff
        self.trie_viewer_state_size_limit = trie_viewer_state_size_limit
        self.block_header_fetch_horizon = block_header_fetch_horizon
        self.header_sync_progress_timeout = header_sync_progress_timeout
        self.state_sync = state_sync
        self.state_requests_per_throttle_period = state_requests_per_throttle_period
        self.save_invalid_witnesses = save_invalid_witnesses
        self.min_block_production_delay = min_block_production_delay
        self.state_sync_external_backoff = state_sync_external_backoff
        self.sync_height_threshold = sync_height_threshold
        self.expected_shutdown = expected_shutdown
        self.header_sync_initial_timeout = header_sync_initial_timeout
        self.header_sync_stall_ban_timeout = header_sync_stall_ban_timeout
        self.epoch_length = epoch_length
        self.block_production_tracking_delay = block_production_tracking_delay
        self.sync_max_block_requests = sync_max_block_requests
        self.rpc_addr = rpc_addr
        self.tracked_shards_config = tracked_shards_config
        self.min_num_peers = min_num_peers
        self.orphan_state_witness_max_size = orphan_state_witness_max_size
        self.cloud_archival_writer = cloud_archival_writer
        self.max_block_wait_delay = max_block_wait_delay
        self.save_tx_outcomes = save_tx_outcomes
        self.tx_routing_height_horizon = tx_routing_height_horizon
        self.max_block_production_delay = max_block_production_delay
        self.log_summary_style = log_summary_style
        self.protocol_version_check = protocol_version_check
        self.save_trie_changes = save_trie_changes
    }
}

public typealias RpcCongestionLevelRequest = AnyCodable

public struct RpcCongestionLevelResponse: Codable, Sendable {
    public let congestion_level: AnyCodable

    public init(congestion_level: AnyCodable) {
        self.congestion_level = congestion_level
    }
}

/// This struct may be returned from JSON RPC server in case of error
It is expected that this struct has impl From<_> all other RPC errors
like [RpcBlockError](crate::types::blocks::RpcBlockError)
public enum RpcError: Codable, Sendable {
    case cause(RpcRequestValidationErrorKind)
    case cause(AnyCodable)
    case cause(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let cause = dict["cause"] {
                self = .cause(try cause.decode(RpcRequestValidationErrorKind.self))
            } else             if let cause = dict["cause"] {
                self = .cause(try cause.decode(AnyCodable.self))
            } else             if let cause = dict["cause"] {
                self = .cause(try cause.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .cause(let value):
            try container.encode(["cause": AnyCodable(value)])
        case .cause(let value):
            try container.encode(["cause": AnyCodable(value)])
        case .cause(let value):
            try container.encode(["cause": AnyCodable(value)])
        }
    }
}

public struct RpcGasPriceRequest: Codable, Sendable {
    public let block_id: AnyCodable?

    public init(block_id: AnyCodable? = nil) {
        self.block_id = block_id
    }
}

public struct RpcGasPriceResponse: Codable, Sendable {
    public let gas_price: String

    public init(gas_price: String) {
        self.gas_price = gas_price
    }
}

public enum RpcHealthRequest: Codable, Sendable {
}

public enum RpcHealthResponse: Codable, Sendable {
}

public struct RpcKnownProducer: Codable, Sendable {
    public let peer_id: PeerId
    public let addr: String?
    public let account_id: AccountId

    public init(peer_id: PeerId, addr: String? = nil, account_id: AccountId) {
        self.peer_id = peer_id
        self.addr = addr
        self.account_id = account_id
    }
}

public struct RpcLightClientBlockProofRequest: Codable, Sendable {
    public let block_hash: CryptoHash
    public let light_client_head: CryptoHash

    public init(block_hash: CryptoHash, light_client_head: CryptoHash) {
        self.block_hash = block_hash
        self.light_client_head = light_client_head
    }
}

public struct RpcLightClientBlockProofResponse: Codable, Sendable {
    public let block_proof: [AnyCodable]
    public let block_header_lite: LightClientBlockLiteView

    public init(block_proof: [AnyCodable], block_header_lite: LightClientBlockLiteView) {
        self.block_proof = block_proof
        self.block_header_lite = block_header_lite
    }
}

public enum RpcLightClientExecutionProofRequest: Codable, Sendable {
    case sender_id(AccountId)
    case type(String)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let sender_id = dict["sender_id"] {
                self = .sender_id(try sender_id.decode(AccountId.self))
            } else             if let type = dict["type"] {
                self = .type(try type.decode(String.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcLightClientExecutionProofRequest")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcLightClientExecutionProofRequest")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .sender_id(let value):
            try container.encode(["sender_id": AnyCodable(value)])
        case .type(let value):
            try container.encode(["type": AnyCodable(value)])
        }
    }
}

public struct RpcLightClientExecutionProofResponse: Codable, Sendable {
    public let outcome_root_proof: [AnyCodable]
    public let block_proof: [AnyCodable]
    public let outcome_proof: ExecutionOutcomeWithIdView
    public let block_header_lite: LightClientBlockLiteView

    public init(outcome_root_proof: [AnyCodable], block_proof: [AnyCodable], outcome_proof: ExecutionOutcomeWithIdView, block_header_lite: LightClientBlockLiteView) {
        self.outcome_root_proof = outcome_root_proof
        self.block_proof = block_proof
        self.outcome_proof = outcome_proof
        self.block_header_lite = block_header_lite
    }
}

public struct RpcLightClientNextBlockRequest: Codable, Sendable {
    public let last_block_hash: CryptoHash

    public init(last_block_hash: CryptoHash) {
        self.last_block_hash = last_block_hash
    }
}

/// A state for the current head of a light client. More info [here](https://nomicon.io/ChainSpec/LightClient).
public struct RpcLightClientNextBlockResponse: Codable, Sendable {
    public let approvals_after_next: [AnyCodable]?
    public let next_bps: [AnyCodable]?
    public let inner_rest_hash: CryptoHash?
    public let next_block_inner_hash: CryptoHash?
    public let prev_block_hash: CryptoHash?
    public let inner_lite: AnyCodable?

    public init(approvals_after_next: [AnyCodable]? = nil, next_bps: [AnyCodable]? = nil, inner_rest_hash: CryptoHash? = nil, next_block_inner_hash: CryptoHash? = nil, prev_block_hash: CryptoHash? = nil, inner_lite: AnyCodable? = nil) {
        self.approvals_after_next = approvals_after_next
        self.next_bps = next_bps
        self.inner_rest_hash = inner_rest_hash
        self.next_block_inner_hash = next_block_inner_hash
        self.prev_block_hash = prev_block_hash
        self.inner_lite = inner_lite
    }
}

public struct RpcMaintenanceWindowsRequest: Codable, Sendable {
    public let account_id: AccountId

    public init(account_id: AccountId) {
        self.account_id = account_id
    }
}

public enum RpcNetworkInfoRequest: Codable, Sendable {
}

public struct RpcNetworkInfoResponse: Codable, Sendable {
    public let active_peers: [AnyCodable]
    public let known_producers: [AnyCodable]
    public let peer_max_count: Int
    public let received_bytes_per_sec: UInt64
    public let num_active_peers: Int
    public let sent_bytes_per_sec: UInt64

    public init(active_peers: [AnyCodable], known_producers: [AnyCodable], peer_max_count: Int, received_bytes_per_sec: UInt64, num_active_peers: Int, sent_bytes_per_sec: UInt64) {
        self.active_peers = active_peers
        self.known_producers = known_producers
        self.peer_max_count = peer_max_count
        self.received_bytes_per_sec = received_bytes_per_sec
        self.num_active_peers = num_active_peers
        self.sent_bytes_per_sec = sent_bytes_per_sec
    }
}

public struct RpcPeerInfo: Codable, Sendable {
    public let addr: String?
    public let account_id: AnyCodable?
    public let id: PeerId

    public init(addr: String? = nil, account_id: AnyCodable? = nil, id: PeerId) {
        self.addr = addr
        self.account_id = account_id
        self.id = id
    }
}

public enum RpcProtocolConfigRequest: Codable, Sendable {
    case block_id(BlockId)
    case finality(Finality)
    case sync_checkpoint(SyncCheckpoint)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let block_id = dict["block_id"] {
                self = .block_id(try block_id.decode(BlockId.self))
            } else             if let finality = dict["finality"] {
                self = .finality(try finality.decode(Finality.self))
            } else             if let sync_checkpoint = dict["sync_checkpoint"] {
                self = .sync_checkpoint(try sync_checkpoint.decode(SyncCheckpoint.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcProtocolConfigRequest")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcProtocolConfigRequest")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .block_id(let value):
            try container.encode(["block_id": AnyCodable(value)])
        case .finality(let value):
            try container.encode(["finality": AnyCodable(value)])
        case .sync_checkpoint(let value):
            try container.encode(["sync_checkpoint": AnyCodable(value)])
        }
    }
}

public struct RpcProtocolConfigResponse: Codable, Sendable {
    public let transaction_validity_period: UInt64
    public let protocol_upgrade_stake_threshold: [Int]
    public let num_block_producer_seats: UInt64
    public let dynamic_resharding: Bool
    public let max_inflation_rate: [Int]
    public let online_min_threshold: [Int]
    public let epoch_length: UInt64
    public let num_block_producer_seats_per_shard: [UInt64]
    public let num_blocks_per_year: UInt64
    public let max_gas_price: String
    public let max_kickout_stake_perc: Int
    public let gas_price_adjustment_rate: [Int]
    public let protocol_version: Int
    public let chain_id: String
    public let block_producer_kickout_threshold: Int
    public let fishermen_threshold: String
    public let avg_hidden_validator_seats_per_shard: [UInt64]
    public let gas_limit: AnyCodable
    public let chunk_producer_kickout_threshold: Int
    public let chunk_validator_only_kickout_threshold: Int
    public let online_max_threshold: [Int]
    public let genesis_height: UInt64
    public let minimum_stake_ratio: [Int]
    public let min_gas_price: String
    public let target_validator_mandates_per_shard: UInt64
    public let runtime_config: AnyCodable
    public let protocol_treasury_account: AnyCodable
    public let genesis_time: String
    public let minimum_validators_per_shard: UInt64
    public let protocol_reward_rate: [Int]
    public let shard_layout: AnyCodable
    public let shuffle_shard_assignment_for_chunk_producers: Bool
    public let minimum_stake_divisor: UInt64

    public init(transaction_validity_period: UInt64, protocol_upgrade_stake_threshold: [Int], num_block_producer_seats: UInt64, dynamic_resharding: Bool, max_inflation_rate: [Int], online_min_threshold: [Int], epoch_length: UInt64, num_block_producer_seats_per_shard: [UInt64], num_blocks_per_year: UInt64, max_gas_price: String, max_kickout_stake_perc: Int, gas_price_adjustment_rate: [Int], protocol_version: Int, chain_id: String, block_producer_kickout_threshold: Int, fishermen_threshold: String, avg_hidden_validator_seats_per_shard: [UInt64], gas_limit: AnyCodable, chunk_producer_kickout_threshold: Int, chunk_validator_only_kickout_threshold: Int, online_max_threshold: [Int], genesis_height: UInt64, minimum_stake_ratio: [Int], min_gas_price: String, target_validator_mandates_per_shard: UInt64, runtime_config: AnyCodable, protocol_treasury_account: AnyCodable, genesis_time: String, minimum_validators_per_shard: UInt64, protocol_reward_rate: [Int], shard_layout: AnyCodable, shuffle_shard_assignment_for_chunk_producers: Bool, minimum_stake_divisor: UInt64) {
        self.transaction_validity_period = transaction_validity_period
        self.protocol_upgrade_stake_threshold = protocol_upgrade_stake_threshold
        self.num_block_producer_seats = num_block_producer_seats
        self.dynamic_resharding = dynamic_resharding
        self.max_inflation_rate = max_inflation_rate
        self.online_min_threshold = online_min_threshold
        self.epoch_length = epoch_length
        self.num_block_producer_seats_per_shard = num_block_producer_seats_per_shard
        self.num_blocks_per_year = num_blocks_per_year
        self.max_gas_price = max_gas_price
        self.max_kickout_stake_perc = max_kickout_stake_perc
        self.gas_price_adjustment_rate = gas_price_adjustment_rate
        self.protocol_version = protocol_version
        self.chain_id = chain_id
        self.block_producer_kickout_threshold = block_producer_kickout_threshold
        self.fishermen_threshold = fishermen_threshold
        self.avg_hidden_validator_seats_per_shard = avg_hidden_validator_seats_per_shard
        self.gas_limit = gas_limit
        self.chunk_producer_kickout_threshold = chunk_producer_kickout_threshold
        self.chunk_validator_only_kickout_threshold = chunk_validator_only_kickout_threshold
        self.online_max_threshold = online_max_threshold
        self.genesis_height = genesis_height
        self.minimum_stake_ratio = minimum_stake_ratio
        self.min_gas_price = min_gas_price
        self.target_validator_mandates_per_shard = target_validator_mandates_per_shard
        self.runtime_config = runtime_config
        self.protocol_treasury_account = protocol_treasury_account
        self.genesis_time = genesis_time
        self.minimum_validators_per_shard = minimum_validators_per_shard
        self.protocol_reward_rate = protocol_reward_rate
        self.shard_layout = shard_layout
        self.shuffle_shard_assignment_for_chunk_producers = shuffle_shard_assignment_for_chunk_producers
        self.minimum_stake_divisor = minimum_stake_divisor
    }
}

public enum RpcQueryRequest: Codable, Sendable {
}

public struct RpcQueryResponse: Codable, Sendable {
    public let block_hash: CryptoHash
    public let block_height: UInt64

    public init(block_hash: CryptoHash, block_height: UInt64) {
        self.block_hash = block_hash
        self.block_height = block_height
    }
}

public struct RpcReceiptRequest: Codable, Sendable {
    public let receipt_id: CryptoHash

    public init(receipt_id: CryptoHash) {
        self.receipt_id = receipt_id
    }
}

public struct RpcReceiptResponse: Codable, Sendable {
    public let receipt: ReceiptEnumView
    public let predecessor_id: AccountId
    public let receipt_id: CryptoHash
    public let priority: UInt64?
    public let receiver_id: AccountId

    public init(receipt: ReceiptEnumView, predecessor_id: AccountId, receipt_id: CryptoHash, priority: UInt64? = nil, receiver_id: AccountId) {
        self.receipt = receipt
        self.predecessor_id = predecessor_id
        self.receipt_id = receipt_id
        self.priority = priority
        self.receiver_id = receiver_id
    }
}

public enum RpcRequestValidationErrorKind: Codable, Sendable {
    case name(String)
    case name(String)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let name = dict["name"] {
                self = .name(try name.decode(String.self))
            } else             if let name = dict["name"] {
                self = .name(try name.decode(String.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcRequestValidationErrorKind")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcRequestValidationErrorKind")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .name(let value):
            try container.encode(["name": AnyCodable(value)])
        case .name(let value):
            try container.encode(["name": AnyCodable(value)])
        }
    }
}

public struct RpcSendTransactionRequest: Codable, Sendable {
    public let signed_tx_base64: SignedTransaction
    public let wait_until: AnyCodable?

    public init(signed_tx_base64: SignedTransaction, wait_until: AnyCodable? = nil) {
        self.signed_tx_base64 = signed_tx_base64
        self.wait_until = wait_until
    }
}

public typealias RpcSplitStorageInfoRequest = AnyCodable

/// Contains the split storage information.
public struct RpcSplitStorageInfoResponse: Codable, Sendable {
    public let hot_db_kind: String?
    public let cold_head_height: UInt64?
    public let head_height: UInt64?
    public let final_head_height: UInt64?

    public init(hot_db_kind: String? = nil, cold_head_height: UInt64? = nil, head_height: UInt64? = nil, final_head_height: UInt64? = nil) {
        self.hot_db_kind = hot_db_kind
        self.cold_head_height = cold_head_height
        self.head_height = head_height
        self.final_head_height = final_head_height
    }
}

/// It is a [serializable view] of [`StateChangesRequest`].

[serializable view]: ./index.html
[`StateChangesRequest`]: ../types/struct.StateChangesRequest.html
public enum RpcStateChangesInBlockByTypeRequest: Codable, Sendable {
}

public struct RpcStateChangesInBlockByTypeResponse: Codable, Sendable {
    public let changes: [AnyCodable]
    public let block_hash: CryptoHash

    public init(changes: [AnyCodable], block_hash: CryptoHash) {
        self.changes = changes
        self.block_hash = block_hash
    }
}

public enum RpcStateChangesInBlockRequest: Codable, Sendable {
    case block_id(BlockId)
    case finality(Finality)
    case sync_checkpoint(SyncCheckpoint)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let block_id = dict["block_id"] {
                self = .block_id(try block_id.decode(BlockId.self))
            } else             if let finality = dict["finality"] {
                self = .finality(try finality.decode(Finality.self))
            } else             if let sync_checkpoint = dict["sync_checkpoint"] {
                self = .sync_checkpoint(try sync_checkpoint.decode(SyncCheckpoint.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcStateChangesInBlockRequest")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcStateChangesInBlockRequest")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .block_id(let value):
            try container.encode(["block_id": AnyCodable(value)])
        case .finality(let value):
            try container.encode(["finality": AnyCodable(value)])
        case .sync_checkpoint(let value):
            try container.encode(["sync_checkpoint": AnyCodable(value)])
        }
    }
}

public struct RpcStateChangesInBlockResponse: Codable, Sendable {
    public let changes: [AnyCodable]
    public let block_hash: CryptoHash

    public init(changes: [AnyCodable], block_hash: CryptoHash) {
        self.changes = changes
        self.block_hash = block_hash
    }
}

public enum RpcStatusRequest: Codable, Sendable {
}

public struct RpcStatusResponse: Codable, Sendable {
    public let latest_protocol_version: Int
    public let rpc_addr: String?
    public let validator_public_key: AnyCodable?
    public let protocol_version: Int
    public let uptime_sec: Int
    public let sync_info: AnyCodable
    public let chain_id: String
    public let validators: [AnyCodable]
    public let validator_account_id: AnyCodable?
    public let node_key: AnyCodable?
    public let version: AnyCodable
    public let genesis_hash: AnyCodable
    public let detailed_debug_status: AnyCodable?
    public let node_public_key: AnyCodable

    public init(latest_protocol_version: Int, rpc_addr: String? = nil, validator_public_key: AnyCodable? = nil, protocol_version: Int, uptime_sec: Int, sync_info: AnyCodable, chain_id: String, validators: [AnyCodable], validator_account_id: AnyCodable? = nil, node_key: AnyCodable? = nil, version: AnyCodable, genesis_hash: AnyCodable, detailed_debug_status: AnyCodable? = nil, node_public_key: AnyCodable) {
        self.latest_protocol_version = latest_protocol_version
        self.rpc_addr = rpc_addr
        self.validator_public_key = validator_public_key
        self.protocol_version = protocol_version
        self.uptime_sec = uptime_sec
        self.sync_info = sync_info
        self.chain_id = chain_id
        self.validators = validators
        self.validator_account_id = validator_account_id
        self.node_key = node_key
        self.version = version
        self.genesis_hash = genesis_hash
        self.detailed_debug_status = detailed_debug_status
        self.node_public_key = node_public_key
    }
}

public struct RpcTransactionResponse: Codable, Sendable {
    public let final_execution_status: TxExecutionStatus

    public init(final_execution_status: TxExecutionStatus) {
        self.final_execution_status = final_execution_status
    }
}

public struct RpcTransactionStatusRequest: Codable, Sendable {
    public let wait_until: AnyCodable?

    public init(wait_until: AnyCodable? = nil) {
        self.wait_until = wait_until
    }
}

public enum RpcValidatorRequest: Codable, Sendable {
    case latest
    case epoch_id(EpochId)
    case block_id(BlockId)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let epoch_id = dict["epoch_id"] {
                self = .epoch_id(try epoch_id.decode(EpochId.self))
            } else             if let block_id = dict["block_id"] {
                self = .block_id(try block_id.decode(BlockId.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcValidatorRequest")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "latest": self = .latest
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcValidatorRequest: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RpcValidatorRequest")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .latest:
            try container.encode("latest")
        case .epoch_id(let value):
            try container.encode(["epoch_id": AnyCodable(value)])
        case .block_id(let value):
            try container.encode(["block_id": AnyCodable(value)])
        }
    }
}

/// Information about this epoch validators and next epoch validators
public struct RpcValidatorResponse: Codable, Sendable {
    public let prev_epoch_kickout: [AnyCodable]
    public let current_validators: [AnyCodable]
    public let epoch_start_height: UInt64
    public let next_validators: [AnyCodable]
    public let next_fishermen: [AnyCodable]
    public let epoch_height: UInt64
    public let current_fishermen: [AnyCodable]
    public let current_proposals: [AnyCodable]

    public init(prev_epoch_kickout: [AnyCodable], current_validators: [AnyCodable], epoch_start_height: UInt64, next_validators: [AnyCodable], next_fishermen: [AnyCodable], epoch_height: UInt64, current_fishermen: [AnyCodable], current_proposals: [AnyCodable]) {
        self.prev_epoch_kickout = prev_epoch_kickout
        self.current_validators = current_validators
        self.epoch_start_height = epoch_start_height
        self.next_validators = next_validators
        self.next_fishermen = next_fishermen
        self.epoch_height = epoch_height
        self.current_fishermen = current_fishermen
        self.current_proposals = current_proposals
    }
}

public struct RpcValidatorsOrderedRequest: Codable, Sendable {
    public let block_id: AnyCodable?

    public init(block_id: AnyCodable? = nil) {
        self.block_id = block_id
    }
}

/// View that preserves JSON format of the runtime config.
public struct RuntimeConfigView: Codable, Sendable {
    public let storage_amount_per_byte: String
    public let account_creation_config: AnyCodable
    public let transaction_costs: AnyCodable
    public let congestion_control_config: AnyCodable
    public let wasm_config: AnyCodable
    public let witness_config: AnyCodable

    public init(storage_amount_per_byte: String, account_creation_config: AnyCodable, transaction_costs: AnyCodable, congestion_control_config: AnyCodable, wasm_config: AnyCodable, witness_config: AnyCodable) {
        self.storage_amount_per_byte = storage_amount_per_byte
        self.account_creation_config = account_creation_config
        self.transaction_costs = transaction_costs
        self.congestion_control_config = congestion_control_config
        self.wasm_config = wasm_config
        self.witness_config = witness_config
    }
}

/// Describes different fees for the runtime
public struct RuntimeFeesConfigView: Codable, Sendable {
    public let burnt_gas_reward: [Int]
    public let pessimistic_gas_price_inflation_ratio: [Int]
    public let action_receipt_creation_config: AnyCodable
    public let data_receipt_creation_config: AnyCodable
    public let storage_usage_config: AnyCodable
    public let action_creation_config: AnyCodable

    public init(burnt_gas_reward: [Int], pessimistic_gas_price_inflation_ratio: [Int], action_receipt_creation_config: AnyCodable, data_receipt_creation_config: AnyCodable, storage_usage_config: AnyCodable, action_creation_config: AnyCodable) {
        self.burnt_gas_reward = burnt_gas_reward
        self.pessimistic_gas_price_inflation_ratio = pessimistic_gas_price_inflation_ratio
        self.action_receipt_creation_config = action_receipt_creation_config
        self.data_receipt_creation_config = data_receipt_creation_config
        self.storage_usage_config = storage_usage_config
        self.action_creation_config = action_creation_config
    }
}

/// The shard identifier. It may be an arbitrary number - it does not need to be
a number in the range 0..NUM_SHARDS. The shard ids do not need to be
sequential or contiguous.

The shard id is wrapped in a new type to prevent the old pattern of using
indices in range 0..NUM_SHARDS and casting to ShardId. Once the transition
if fully complete it potentially may be simplified to a regular type alias.
public typealias ShardId = Int

/// A versioned struct that contains all information needed to assign accounts to shards.

Because of re-sharding, the chain may use different shard layout to split shards at different
times. Currently, `ShardLayout` is stored as part of `EpochConfig`, which is generated each
epoch given the epoch protocol version. In mainnet/testnet, we use two shard layouts since
re-sharding has only happened once. It is stored as part of genesis config, see
default_simple_nightshade_shard_layout() Below is an overview for some important
functionalities of ShardLayout interface.
public enum ShardLayout: Codable, Sendable {
    case V0(ShardLayoutV0)
    case V1(ShardLayoutV1)
    case V2(ShardLayoutV2)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let v0 = dict["V0"] {
                self = .V0(try v0.decode(ShardLayoutV0.self))
            } else             if let v1 = dict["V1"] {
                self = .V1(try v1.decode(ShardLayoutV1.self))
            } else             if let v2 = dict["V2"] {
                self = .V2(try v2.decode(ShardLayoutV2.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ShardLayout")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ShardLayout")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .V0(let value):
            try container.encode(["V0": AnyCodable(value)])
        case .V1(let value):
            try container.encode(["V1": AnyCodable(value)])
        case .V2(let value):
            try container.encode(["V2": AnyCodable(value)])
        }
    }
}

/// A shard layout that maps accounts evenly across all shards -- by calculate the hash of account
id and mod number of shards. This is added to capture the old `account_id_to_shard_id` algorithm,
to keep backward compatibility for some existing tests.
`parent_shards` for `ShardLayoutV1` is always `None`, meaning it can only be the first shard layout
a chain uses.
public struct ShardLayoutV0: Codable, Sendable {
    public let version: Int
    public let num_shards: UInt64

    public init(version: Int, num_shards: UInt64) {
        self.version = version
        self.num_shards = num_shards
    }
}

public struct ShardLayoutV1: Codable, Sendable {
    public let version: Int
    public let to_parent_shard_map: [AnyCodable]?
    public let shards_split_map: [[AnyCodable]]?
    public let boundary_accounts: [AnyCodable]

    public init(version: Int, to_parent_shard_map: [AnyCodable]? = nil, shards_split_map: [[AnyCodable]]? = nil, boundary_accounts: [AnyCodable]) {
        self.version = version
        self.to_parent_shard_map = to_parent_shard_map
        self.shards_split_map = shards_split_map
        self.boundary_accounts = boundary_accounts
    }
}

/// Counterpart to `ShardLayoutV2` composed of maps with string keys to aid
serde serialization.
public struct ShardLayoutV2: Codable, Sendable {
    public let shards_parent_map: AnyCodable?
    public let shards_split_map: AnyCodable?
    public let shard_ids: [AnyCodable]
    public let index_to_id_map: AnyCodable
    public let id_to_index_map: AnyCodable
    public let boundary_accounts: [AnyCodable]
    public let version: Int

    public init(shards_parent_map: AnyCodable? = nil, shards_split_map: AnyCodable? = nil, shard_ids: [AnyCodable], index_to_id_map: AnyCodable, id_to_index_map: AnyCodable, boundary_accounts: [AnyCodable], version: Int) {
        self.shards_parent_map = shards_parent_map
        self.shards_split_map = shards_split_map
        self.shard_ids = shard_ids
        self.index_to_id_map = index_to_id_map
        self.id_to_index_map = id_to_index_map
        self.boundary_accounts = boundary_accounts
        self.version = version
    }
}

/// `ShardUId` is a unique representation for shards from different shard layouts.

Comparing to `ShardId`, which is just an ordinal number ranging from 0 to NUM_SHARDS-1,
`ShardUId` provides a way to unique identify shards when shard layouts may change across epochs.
This is important because we store states indexed by shards in our database, so we need a
way to unique identify shard even when shards change across epochs.
Another difference between `ShardUId` and `ShardId` is that `ShardUId` should only exist in
a node's internal state while `ShardId` can be exposed to outside APIs and used in protocol
level information (for example, `ShardChunkHeader` contains `ShardId` instead of `ShardUId`)
public struct ShardUId: Codable, Sendable {
    public let shard_id: Int
    public let version: Int

    public init(shard_id: Int, version: Int) {
        self.shard_id = shard_id
        self.version = version
    }
}

public typealias Signature = String

public struct SignedDelegateAction: Codable, Sendable {
    public let delegate_action: DelegateAction
    public let signature: Signature

    public init(delegate_action: DelegateAction, signature: Signature) {
        self.delegate_action = delegate_action
        self.signature = signature
    }
}

public typealias SignedTransaction = String

public struct SignedTransactionView: Codable, Sendable {
    public let signer_id: AccountId
    public let signature: Signature
    public let receiver_id: AccountId
    public let priority_fee: UInt64?
    public let public_key: PublicKey
    public let nonce: UInt64
    public let actions: [AnyCodable]
    public let hash: CryptoHash

    public init(signer_id: AccountId, signature: Signature, receiver_id: AccountId, priority_fee: UInt64? = nil, public_key: PublicKey, nonce: UInt64, actions: [AnyCodable], hash: CryptoHash) {
        self.signer_id = signer_id
        self.signature = signature
        self.receiver_id = receiver_id
        self.priority_fee = priority_fee
        self.public_key = public_key
        self.nonce = nonce
        self.actions = actions
        self.hash = hash
    }
}

public struct SlashedValidator: Codable, Sendable {
    public let is_double_sign: Bool
    public let account_id: AccountId

    public init(is_double_sign: Bool, account_id: AccountId) {
        self.is_double_sign = is_double_sign
        self.account_id = account_id
    }
}

/// An action which stakes signer_id tokens and setup's validator public key
public struct StakeAction: Codable, Sendable {
    public let stake: String
    public let public_key: AnyCodable

    public init(stake: String, public_key: AnyCodable) {
        self.stake = stake
        self.public_key = public_key
    }
}

/// See crate::types::StateChangeCause for details.
public enum StateChangeCauseView: Codable, Sendable {
    case type(String)
    case type(String)
    case tx_hash(CryptoHash)
    case receipt_hash(CryptoHash)
    case receipt_hash(CryptoHash)
    case receipt_hash(CryptoHash)
    case receipt_hash(CryptoHash)
    case type(String)
    case type(String)
    case type(String)
    case type(String)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let type = dict["type"] {
                self = .type(try type.decode(String.self))
            } else             if let type = dict["type"] {
                self = .type(try type.decode(String.self))
            } else             if let tx_hash = dict["tx_hash"] {
                self = .tx_hash(try tx_hash.decode(CryptoHash.self))
            } else             if let receipt_hash = dict["receipt_hash"] {
                self = .receipt_hash(try receipt_hash.decode(CryptoHash.self))
            } else             if let receipt_hash = dict["receipt_hash"] {
                self = .receipt_hash(try receipt_hash.decode(CryptoHash.self))
            } else             if let receipt_hash = dict["receipt_hash"] {
                self = .receipt_hash(try receipt_hash.decode(CryptoHash.self))
            } else             if let receipt_hash = dict["receipt_hash"] {
                self = .receipt_hash(try receipt_hash.decode(CryptoHash.self))
            } else             if let type = dict["type"] {
                self = .type(try type.decode(String.self))
            } else             if let type = dict["type"] {
                self = .type(try type.decode(String.self))
            } else             if let type = dict["type"] {
                self = .type(try type.decode(String.self))
            } else             if let type = dict["type"] {
                self = .type(try type.decode(String.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StateChangeCauseView")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StateChangeCauseView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .type(let value):
            try container.encode(["type": AnyCodable(value)])
        case .type(let value):
            try container.encode(["type": AnyCodable(value)])
        case .tx_hash(let value):
            try container.encode(["tx_hash": AnyCodable(value)])
        case .receipt_hash(let value):
            try container.encode(["receipt_hash": AnyCodable(value)])
        case .receipt_hash(let value):
            try container.encode(["receipt_hash": AnyCodable(value)])
        case .receipt_hash(let value):
            try container.encode(["receipt_hash": AnyCodable(value)])
        case .receipt_hash(let value):
            try container.encode(["receipt_hash": AnyCodable(value)])
        case .type(let value):
            try container.encode(["type": AnyCodable(value)])
        case .type(let value):
            try container.encode(["type": AnyCodable(value)])
        case .type(let value):
            try container.encode(["type": AnyCodable(value)])
        case .type(let value):
            try container.encode(["type": AnyCodable(value)])
        }
    }
}

/// It is a [serializable view] of [`StateChangeKind`].

[serializable view]: ./index.html
[`StateChangeKind`]: ../types/struct.StateChangeKind.html
public enum StateChangeKindView: Codable, Sendable {
    case account_id(AccountId)
    case account_id(AccountId)
    case account_id(AccountId)
    case account_id(AccountId)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let account_id = dict["account_id"] {
                self = .account_id(try account_id.decode(AccountId.self))
            } else             if let account_id = dict["account_id"] {
                self = .account_id(try account_id.decode(AccountId.self))
            } else             if let account_id = dict["account_id"] {
                self = .account_id(try account_id.decode(AccountId.self))
            } else             if let account_id = dict["account_id"] {
                self = .account_id(try account_id.decode(AccountId.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StateChangeKindView")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StateChangeKindView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .account_id(let value):
            try container.encode(["account_id": AnyCodable(value)])
        case .account_id(let value):
            try container.encode(["account_id": AnyCodable(value)])
        case .account_id(let value):
            try container.encode(["account_id": AnyCodable(value)])
        case .account_id(let value):
            try container.encode(["account_id": AnyCodable(value)])
        }
    }
}

public enum StateChangeWithCauseView: Codable, Sendable {
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)
    case change(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else             if let change = dict["change"] {
                self = .change(try change.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StateChangeWithCauseView")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StateChangeWithCauseView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        case .change(let value):
            try container.encode(["change": AnyCodable(value)])
        }
    }
}

/// Item of the state, key and value are serialized in base64 and proof for inclusion of given state item.
public struct StateItem: Codable, Sendable {
    public let key: StoreKey
    public let value: StoreValue

    public init(key: StoreKey, value: StoreValue) {
        self.key = key
        self.value = value
    }
}

public struct StateSyncConfig: Codable, Sendable {
    public let dump: AnyCodable?
    public let sync: SyncConfig?
    public let concurrency: SyncConcurrency?
    public let parts_compression_lvl: Int?

    public init(dump: AnyCodable? = nil, sync: SyncConfig? = nil, concurrency: SyncConcurrency? = nil, parts_compression_lvl: Int? = nil) {
        self.dump = dump
        self.sync = sync
        self.concurrency = concurrency
        self.parts_compression_lvl = parts_compression_lvl
    }
}

public struct StatusSyncInfo: Codable, Sendable {
    public let latest_block_time: String
    public let epoch_start_height: UInt64?
    public let latest_state_root: CryptoHash
    public let syncing: Bool
    public let epoch_id: AnyCodable?
    public let earliest_block_hash: AnyCodable?
    public let earliest_block_time: String?
    public let earliest_block_height: UInt64?
    public let latest_block_height: UInt64
    public let latest_block_hash: CryptoHash

    public init(latest_block_time: String, epoch_start_height: UInt64? = nil, latest_state_root: CryptoHash, syncing: Bool, epoch_id: AnyCodable? = nil, earliest_block_hash: AnyCodable? = nil, earliest_block_time: String? = nil, earliest_block_height: UInt64? = nil, latest_block_height: UInt64, latest_block_hash: CryptoHash) {
        self.latest_block_time = latest_block_time
        self.epoch_start_height = epoch_start_height
        self.latest_state_root = latest_state_root
        self.syncing = syncing
        self.epoch_id = epoch_id
        self.earliest_block_hash = earliest_block_hash
        self.earliest_block_time = earliest_block_time
        self.earliest_block_height = earliest_block_height
        self.latest_block_height = latest_block_height
        self.latest_block_hash = latest_block_hash
    }
}

/// Errors which may occur during working with trie storages, storing
trie values (trie nodes and state values) by their hashes.
public enum StorageError: Codable, Sendable {
    case StorageInternalError
    case MissingTrieValue(MissingTrieValue)
    case UnexpectedTrieValue
    case StorageInconsistentState(String)
    case FlatStorageBlockNotSupported(String)
    case MemTrieLoadingError(String)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let missingtrievalue = dict["MissingTrieValue"] {
                self = .MissingTrieValue(try missingtrievalue.decode(MissingTrieValue.self))
            } else             if let storageinconsistentstate = dict["StorageInconsistentState"] {
                self = .StorageInconsistentState(try storageinconsistentstate.decode(String.self))
            } else             if let flatstorageblocknotsupported = dict["FlatStorageBlockNotSupported"] {
                self = .FlatStorageBlockNotSupported(try flatstorageblocknotsupported.decode(String.self))
            } else             if let memtrieloadingerror = dict["MemTrieLoadingError"] {
                self = .MemTrieLoadingError(try memtrieloadingerror.decode(String.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StorageError")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "StorageInternalError": self = .StorageInternalError
            case "UnexpectedTrieValue": self = .UnexpectedTrieValue
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StorageError: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid StorageError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .StorageInternalError:
            try container.encode("StorageInternalError")
        case .MissingTrieValue(let value):
            try container.encode(["MissingTrieValue": AnyCodable(value)])
        case .UnexpectedTrieValue:
            try container.encode("UnexpectedTrieValue")
        case .StorageInconsistentState(let value):
            try container.encode(["StorageInconsistentState": AnyCodable(value)])
        case .FlatStorageBlockNotSupported(let value):
            try container.encode(["FlatStorageBlockNotSupported": AnyCodable(value)])
        case .MemTrieLoadingError(let value):
            try container.encode(["MemTrieLoadingError": AnyCodable(value)])
        }
    }
}

/// This enum represents if a storage_get call will be performed through flat storage or trie
public enum StorageGetMode: Codable, Sendable {
    case FlatStorage
    case Trie
}

/// Describes cost of storage per block
public struct StorageUsageConfigView: Codable, Sendable {
    public let num_extra_bytes_record: UInt64
    public let num_bytes_account: UInt64

    public init(num_extra_bytes_record: UInt64, num_bytes_account: UInt64) {
        self.num_extra_bytes_record = num_extra_bytes_record
        self.num_bytes_account = num_bytes_account
    }
}

/// This type is used to mark keys (arrays of bytes) that are queried from store.

NOTE: Currently, this type is only used in the view_client and RPC to be able to transparently
pretty-serialize the bytes arrays as base64-encoded strings (see `serialize.rs`).
public typealias StoreKey = String

/// This type is used to mark values returned from store (arrays of bytes).

NOTE: Currently, this type is only used in the view_client and RPC to be able to transparently
pretty-serialize the bytes arrays as base64-encoded strings (see `serialize.rs`).
public typealias StoreValue = String

public enum SyncCheckpoint: Codable, Sendable {
    case genesis
    case earliest_available
}

public struct SyncConcurrency: Codable, Sendable {
    public let peer_downloads: Int
    public let per_shard: Int
    public let apply_during_catchup: Int
    public let apply: Int

    public init(peer_downloads: Int, per_shard: Int, apply_during_catchup: Int, apply: Int) {
        self.peer_downloads = peer_downloads
        self.per_shard = per_shard
        self.apply_during_catchup = apply_during_catchup
        self.apply = apply
    }
}

/// Configures how to fetch state parts during state sync.
public enum SyncConfig: Codable, Sendable {
    case Peers
    case ExternalStorage(ExternalStorageConfig)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let externalstorage = dict["ExternalStorage"] {
                self = .ExternalStorage(try externalstorage.decode(ExternalStorageConfig.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid SyncConfig")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "Peers": self = .Peers
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid SyncConfig: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid SyncConfig")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .Peers:
            try container.encode("Peers")
        case .ExternalStorage(let value):
            try container.encode(["ExternalStorage": AnyCodable(value)])
        }
    }
}

public struct Tier1ProxyView: Codable, Sendable {
    public let peer_id: PublicKey
    public let addr: String

    public init(peer_id: PublicKey, addr: String) {
        self.peer_id = peer_id
        self.addr = addr
    }
}

/// Describes the expected behavior of the node regarding shard tracking.
If the node is an active validator, it will also track the shards it is responsible for as a validator.
public enum TrackedShardsConfig: Codable, Sendable {
    case NoShards
    case Shards([AnyCodable])
    case AllShards
    case ShadowValidator(AccountId)
    case Schedule([[AnyCodable]])
    case Accounts([AnyCodable])

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let shards = dict["Shards"] {
                self = .Shards(try shards.decode([AnyCodable].self))
            } else             if let shadowvalidator = dict["ShadowValidator"] {
                self = .ShadowValidator(try shadowvalidator.decode(AccountId.self))
            } else             if let schedule = dict["Schedule"] {
                self = .Schedule(try schedule.decode([[AnyCodable]].self))
            } else             if let accounts = dict["Accounts"] {
                self = .Accounts(try accounts.decode([AnyCodable].self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid TrackedShardsConfig")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "NoShards": self = .NoShards
            case "AllShards": self = .AllShards
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid TrackedShardsConfig: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid TrackedShardsConfig")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .NoShards:
            try container.encode("NoShards")
        case .Shards(let value):
            try container.encode(["Shards": AnyCodable(value)])
        case .AllShards:
            try container.encode("AllShards")
        case .ShadowValidator(let value):
            try container.encode(["ShadowValidator": AnyCodable(value)])
        case .Schedule(let value):
            try container.encode(["Schedule": AnyCodable(value)])
        case .Accounts(let value):
            try container.encode(["Accounts": AnyCodable(value)])
        }
    }
}

public struct TransferAction: Codable, Sendable {
    public let deposit: String

    public init(deposit: String) {
        self.deposit = deposit
    }
}

/// Error returned in the ExecutionOutcome in case of failure
public enum TxExecutionError: Codable, Sendable {
    case ActionError(ActionError)
    case InvalidTxError(InvalidTxError)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let actionerror = dict["ActionError"] {
                self = .ActionError(try actionerror.decode(ActionError.self))
            } else             if let invalidtxerror = dict["InvalidTxError"] {
                self = .InvalidTxError(try invalidtxerror.decode(InvalidTxError.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid TxExecutionError")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid TxExecutionError")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .ActionError(let value):
            try container.encode(["ActionError": AnyCodable(value)])
        case .InvalidTxError(let value):
            try container.encode(["InvalidTxError": AnyCodable(value)])
        }
    }
}

public enum TxExecutionStatus: Codable, Sendable {
    case NONE
    case INCLUDED
    case EXECUTED_OPTIMISTIC
    case INCLUDED_FINAL
    case EXECUTED
    case FINAL
}

/// Use global contract action
public struct UseGlobalContractAction: Codable, Sendable {
    public let contract_identifier: GlobalContractIdentifier

    public init(contract_identifier: GlobalContractIdentifier) {
        self.contract_identifier = contract_identifier
    }
}

public struct VMConfigView: Codable, Sendable {
    public let reftypes_bulk_memory: Bool
    public let saturating_float_to_int: Bool
    public let regular_op_cost: Int
    public let global_contract_host_fns: Bool
    public let limit_config: AnyCodable
    public let discard_custom_sections: Bool
    public let deterministic_account_ids: Bool
    public let eth_implicit_accounts: Bool
    public let ext_costs: AnyCodable
    public let implicit_account_creation: Bool
    public let fix_contract_loading_cost: Bool
    public let storage_get_mode: AnyCodable
    public let vm_kind: AnyCodable
    public let grow_mem_cost: Int

    public init(reftypes_bulk_memory: Bool, saturating_float_to_int: Bool, regular_op_cost: Int, global_contract_host_fns: Bool, limit_config: AnyCodable, discard_custom_sections: Bool, deterministic_account_ids: Bool, eth_implicit_accounts: Bool, ext_costs: AnyCodable, implicit_account_creation: Bool, fix_contract_loading_cost: Bool, storage_get_mode: AnyCodable, vm_kind: AnyCodable, grow_mem_cost: Int) {
        self.reftypes_bulk_memory = reftypes_bulk_memory
        self.saturating_float_to_int = saturating_float_to_int
        self.regular_op_cost = regular_op_cost
        self.global_contract_host_fns = global_contract_host_fns
        self.limit_config = limit_config
        self.discard_custom_sections = discard_custom_sections
        self.deterministic_account_ids = deterministic_account_ids
        self.eth_implicit_accounts = eth_implicit_accounts
        self.ext_costs = ext_costs
        self.implicit_account_creation = implicit_account_creation
        self.fix_contract_loading_cost = fix_contract_loading_cost
        self.storage_get_mode = storage_get_mode
        self.vm_kind = vm_kind
        self.grow_mem_cost = grow_mem_cost
    }
}

public enum VMKind: Codable, Sendable {
    case Wasmer0
    case Wasmtime
    case Wasmer2
    case NearVm
    case NearVm2
}

public struct ValidatorInfo: Codable, Sendable {
    public let account_id: AccountId

    public init(account_id: AccountId) {
        self.account_id = account_id
    }
}

/// Reasons for removing a validator from the validator set.
public enum ValidatorKickoutReason: Codable, Sendable {
    case _UnusedSlashed
    case NotEnoughBlocks(AnyCodable)
    case NotEnoughChunks(AnyCodable)
    case Unstaked
    case NotEnoughStake(AnyCodable)
    case DidNotGetASeat
    case NotEnoughChunkEndorsements(AnyCodable)
    case ProtocolVersionTooOld(AnyCodable)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let notenoughblocks = dict["NotEnoughBlocks"] {
                self = .NotEnoughBlocks(try notenoughblocks.decode(AnyCodable.self))
            } else             if let notenoughchunks = dict["NotEnoughChunks"] {
                self = .NotEnoughChunks(try notenoughchunks.decode(AnyCodable.self))
            } else             if let notenoughstake = dict["NotEnoughStake"] {
                self = .NotEnoughStake(try notenoughstake.decode(AnyCodable.self))
            } else             if let notenoughchunkendorsements = dict["NotEnoughChunkEndorsements"] {
                self = .NotEnoughChunkEndorsements(try notenoughchunkendorsements.decode(AnyCodable.self))
            } else             if let protocolversiontooold = dict["ProtocolVersionTooOld"] {
                self = .ProtocolVersionTooOld(try protocolversiontooold.decode(AnyCodable.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ValidatorKickoutReason")
            }
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "_UnusedSlashed": self = ._UnusedSlashed
            case "Unstaked": self = .Unstaked
            case "DidNotGetASeat": self = .DidNotGetASeat
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ValidatorKickoutReason: \(stringValue)")
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ValidatorKickoutReason")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case ._UnusedSlashed:
            try container.encode("_UnusedSlashed")
        case .NotEnoughBlocks(let value):
            try container.encode(["NotEnoughBlocks": AnyCodable(value)])
        case .NotEnoughChunks(let value):
            try container.encode(["NotEnoughChunks": AnyCodable(value)])
        case .Unstaked:
            try container.encode("Unstaked")
        case .NotEnoughStake(let value):
            try container.encode(["NotEnoughStake": AnyCodable(value)])
        case .DidNotGetASeat:
            try container.encode("DidNotGetASeat")
        case .NotEnoughChunkEndorsements(let value):
            try container.encode(["NotEnoughChunkEndorsements": AnyCodable(value)])
        case .ProtocolVersionTooOld(let value):
            try container.encode(["ProtocolVersionTooOld": AnyCodable(value)])
        }
    }
}

public struct ValidatorKickoutView: Codable, Sendable {
    public let reason: ValidatorKickoutReason
    public let account_id: AccountId

    public init(reason: ValidatorKickoutReason, account_id: AccountId) {
        self.reason = reason
        self.account_id = account_id
    }
}

public enum ValidatorStakeView: Codable, Sendable {
    case validator_stake_struct_version(String)

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: AnyCodable].self) {
            if let validator_stake_struct_version = dict["validator_stake_struct_version"] {
                self = .validator_stake_struct_version(try validator_stake_struct_version.decode(String.self))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ValidatorStakeView")
            }
        } else if let stringValue = try? container.decode(String.self) {
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ValidatorStakeView")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .validator_stake_struct_version(let value):
            try container.encode(["validator_stake_struct_version": AnyCodable(value)])
        }
    }
}

public struct ValidatorStakeViewV1: Codable, Sendable {
    public let public_key: PublicKey
    public let account_id: AccountId
    public let stake: String

    public init(public_key: PublicKey, account_id: AccountId, stake: String) {
        self.public_key = public_key
        self.account_id = account_id
        self.stake = stake
    }
}

/// Data structure for semver version and github tag or commit.
public struct Version: Codable, Sendable {
    public let version: String
    public let rustc_version: String?
    public let build: String
    public let commit: String

    public init(version: String, rustc_version: String? = nil, build: String, commit: String) {
        self.version = version
        self.rustc_version = rustc_version
        self.build = build
        self.commit = commit
    }
}

/// Resulting state values for a view state query request
public struct ViewStateResult: Codable, Sendable {
    public let proof: [String]?
    public let values: [AnyCodable]

    public init(proof: [String]? = nil, values: [AnyCodable]) {
        self.proof = proof
        self.values = values
    }
}

/// A kind of a trap happened during execution of a binary
public enum WasmTrap: Codable, Sendable {
    case Unreachable
    case IncorrectCallIndirectSignature
    case MemoryOutOfBounds
    case CallIndirectOOB
    case IllegalArithmetic
    case MisalignedAtomicAccess
    case IndirectCallToNull
    case StackOverflow
    case GenericTrap
}

/// Configuration specific to ChunkStateWitness.
public struct WitnessConfigView: Codable, Sendable {
    public let main_storage_proof_size_soft_limit: UInt64
    public let new_transactions_validation_state_size_soft_limit: UInt64
    public let combined_transactions_size_limit: Int

    public init(main_storage_proof_size_soft_limit: UInt64, new_transactions_validation_state_size_soft_limit: UInt64, combined_transactions_size_limit: Int) {
        self.main_storage_proof_size_soft_limit = main_storage_proof_size_soft_limit
        self.new_transactions_validation_state_size_soft_limit = new_transactions_validation_state_size_soft_limit
        self.combined_transactions_size_limit = combined_transactions_size_limit
    }
}

