// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MGovernance.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

struct GovernanceInfoStruct {
    mapping(address => bool) effectiveGovernors;
    address candidateGovernor;
    bool initialized;
}

abstract contract MGovernance {
    function _isGovernor(address testGovernor) internal view virtual returns (bool);

    /*
      Allows calling the function only by a Governor.
    */
    modifier onlyGovernance() {
        require(_isGovernor(msg.sender), "ONLY_GOVERNANCE");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/GovernanceStorage.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Holds the governance slots for ALL entities, including proxy and the main contract.
*/
contract GovernanceStorage {
    // A map from a Governor tag to its own GovernanceInfoStruct.
    mapping(string => GovernanceInfoStruct) internal governanceInfo; //NOLINT uninitialized-state.
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/upgrade/ProxyStorage.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Holds the Proxy-specific state variables.
  This contract is inherited by the GovernanceStorage (and indirectly by MainStorage)
  to prevent collision hazard.
*/
contract ProxyStorage is GovernanceStorage {
    // NOLINTNEXTLINE: naming-convention uninitialized-state.
    mapping(address => bytes32) internal initializationHash_DEPRECATED;

    // The time after which we can switch to the implementation.
    // Hash(implementation, data, finalize) => time.
    mapping(bytes32 => uint256) internal enabledTime;

    // A central storage of the flags whether implementation has been initialized.
    // Note - it can be used flexibly enough to accommodate multiple levels of initialization
    // (i.e. using different key salting schemes for different initialization levels).
    mapping(bytes32 => bool) internal initialized;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/libraries/Common.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Common Utility librarries.
  I. Addresses (extending address).
*/
library Addresses {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function performEthTransfer(address recipient, uint256 amount) internal {
        (bool success, ) = recipient.call{value: amount}(""); // NOLINT: low-level-calls.
        require(success, "ETH_TRANSFER_FAILED");
    }

    /*
      Safe wrapper around ERC20/ERC721 calls.
      This is required because many deployed ERC20 contracts don't return a value.
      See https://github.com/ethereum/solidity/issues/4116.
    */
    function safeTokenContractCall(address tokenAddress, bytes memory callData) internal {
        require(isContract(tokenAddress), "BAD_TOKEN_ADDRESS");
        // NOLINTNEXTLINE: low-level-calls.
        (bool success, bytes memory returndata) = tokenAddress.call(callData);
        require(success, string(returndata));

        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "TOKEN_OPERATION_FAILED");
        }
    }

    /*
      Validates that the passed contract address is of a real contract,
      and that its id hash (as infered fromn identify()) matched the expected one.
    */
    function validateContractId(address contractAddress, bytes32 expectedIdHash) internal {
        require(isContract(contractAddress), "ADDRESS_NOT_CONTRACT");
        (bool success, bytes memory returndata) = contractAddress.call( // NOLINT: low-level-calls.
            abi.encodeWithSignature("identify()")
        );
        require(success, "FAILED_TO_IDENTIFY_CONTRACT");
        string memory realContractId = abi.decode(returndata, (string));
        require(
            keccak256(abi.encodePacked(realContractId)) == expectedIdHash,
            "UNEXPECTED_CONTRACT_IDENTIFIER"
        );
    }
}

/*
  II. StarkExTypes - Common data types.
*/
library StarkExTypes {
    // Structure representing a list of verifiers (validity/availability).
    // A statement is valid only if all the verifiers in the list agree on it.
    // Adding a verifier to the list is immediate - this is used for fast resolution of
    // any soundness issues.
    // Removing from the list is time-locked, to ensure that any user of the system
    // not content with the announced removal has ample time to leave the system before it is
    // removed.
    struct ApprovalChainData {
        address[] list;
        // Represents the time after which the verifier with the given address can be removed.
        // Removal of the verifier with address A is allowed only in the case the value
        // of unlockedForRemovalTime[A] != 0 and unlockedForRemovalTime[A] < (current time).
        mapping(address => uint256) unlockedForRemovalTime;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/MainStorage.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


/*
  Holds ALL the main contract state (storage) variables.
*/
contract MainStorage is ProxyStorage {
    uint256 internal constant LAYOUT_LENGTH = 2**64;

    address escapeVerifierAddress; // NOLINT: constable-states.

    // Global dex-frozen flag.
    bool stateFrozen; // NOLINT: constable-states.

    // Time when unFreeze can be successfully called (UNFREEZE_DELAY after freeze).
    uint256 unFreezeTime; // NOLINT: constable-states.

    // Pending deposits.
    // A map STARK key => asset id => vault id => quantized amount.
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) pendingDeposits;

    // Cancellation requests.
    // A map STARK key => asset id => vault id => request timestamp.
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) cancellationRequests;

    // Pending withdrawals.
    // A map STARK key => asset id => quantized amount.
    mapping(uint256 => mapping(uint256 => uint256)) pendingWithdrawals;

    // vault_id => escape used boolean.
    mapping(uint256 => bool) escapesUsed;

    // Number of escapes that were performed when frozen.
    uint256 escapesUsedCount; // NOLINT: constable-states.

    // NOTE: fullWithdrawalRequests is deprecated, and replaced by forcedActionRequests.
    // NOLINTNEXTLINE naming-convention.
    mapping(uint256 => mapping(uint256 => uint256)) fullWithdrawalRequests_DEPRECATED;

    // State sequence number.
    uint256 sequenceNumber; // NOLINT: constable-states uninitialized-state.

    // Validium Vaults Tree Root & Height.
    uint256 validiumVaultRoot; // NOLINT: constable-states uninitialized-state.
    uint256 validiumTreeHeight; // NOLINT: constable-states uninitialized-state.

    // Order Tree Root & Height.
    uint256 orderRoot; // NOLINT: constable-states uninitialized-state.
    uint256 orderTreeHeight; // NOLINT: constable-states uninitialized-state.

    // True if and only if the address is allowed to add tokens.
    mapping(address => bool) tokenAdmins;

    // This mapping is no longer in use, remains for backwards compatibility.
    mapping(address => bool) userAdmins_DEPRECATED; // NOLINT: naming-convention.

    // True if and only if the address is an operator (allowed to update state).
    mapping(address => bool) operators; // NOLINT: uninitialized-state.

    // Mapping of contract ID to asset data.
    mapping(uint256 => bytes) assetTypeToAssetInfo; // NOLINT: uninitialized-state.

    // Mapping of registered contract IDs.
    mapping(uint256 => bool) registeredAssetType; // NOLINT: uninitialized-state.

    // Mapping from contract ID to quantum.
    mapping(uint256 => uint256) assetTypeToQuantum; // NOLINT: uninitialized-state.

    // This mapping is no longer in use, remains for backwards compatibility.
    mapping(address => uint256) starkKeys_DEPRECATED; // NOLINT: naming-convention.

    // Mapping from STARK public key to the Ethereum public key of its owner.
    mapping(uint256 => address) ethKeys; // NOLINT: uninitialized-state.

    // Timelocked state transition and availability verification chain.
    StarkExTypes.ApprovalChainData verifiersChain;
    StarkExTypes.ApprovalChainData availabilityVerifiersChain;

    // Batch id of last accepted proof.
    uint256 lastBatchId; // NOLINT: constable-states uninitialized-state.

    // Mapping between sub-contract index to sub-contract address.
    mapping(uint256 => address) subContracts; // NOLINT: uninitialized-state.

    mapping(uint256 => bool) permissiveAssetType_DEPRECATED; // NOLINT: naming-convention.
    // ---- END OF MAIN STORAGE AS DEPLOYED IN STARKEX2.0 ----

    // Onchain-data version configured for the system.
    uint256 onchainDataVersion_DEPRECATED; // NOLINT: naming-convention constable-states.

    // Counter of forced action request in block. The key is the block number.
    mapping(uint256 => uint256) forcedRequestsInBlock;

    // ForcedAction requests: actionHash => requestTime.
    mapping(bytes32 => uint256) forcedActionRequests;

    // Mapping for timelocked actions.
    // A actionKey => activation time.
    mapping(bytes32 => uint256) actionsTimeLock;

    // Append only list of requested forced action hashes.
    bytes32[] actionHashList;
    // ---- END OF MAIN STORAGE AS DEPLOYED IN STARKEX3.0 ----
    // ---- END OF MAIN STORAGE AS DEPLOYED IN STARKEX4.0 ----

    // Rollup Vaults Tree Root & Height.
    uint256 rollupVaultRoot; // NOLINT: constable-states uninitialized-state.
    uint256 rollupTreeHeight; // NOLINT: constable-states uninitialized-state.

    uint256 globalConfigCode; // NOLINT: constable-states uninitialized-state.

    // Reserved storage space for Extensibility.
    // Every added MUST be added above the end gap, and the __endGap size must be reduced
    // accordingly.
    // NOLINTNEXTLINE: naming-convention.
    uint256[LAYOUT_LENGTH - 40] private __endGap; // __endGap complements layout to LAYOUT_LENGTH.
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/components/PerpetualStorage.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Extends MainStorage, holds Perpetual App specific state (storage) variables.

  ALL State variables that are common to all applications, reside in MainStorage,
  whereas ALL the Perpetual app specific ones reside here.
*/
contract PerpetualStorage is MainStorage {
    uint256 systemAssetType; // NOLINT: constable-states uninitialized-state.

    bytes32 public globalConfigurationHash; // NOLINT: constable-states uninitialized-state.

    mapping(uint256 => bytes32) public configurationHash; // NOLINT: uninitialized-state.

    bytes32 sharedStateHash; // NOLINT: constable-states uninitialized-state.

    // Configuration apply time-lock.
    // The delay is held in storage (and not constant)
    // So that it can be modified during upgrade.
    uint256 public configurationDelay; // NOLINT: constable-states.

    // Reserved storage space for Extensibility.
    // Every added MUST be added above the end gap, and the __endGap size must be reduced
    // accordingly.
    // NOLINTNEXTLINE: naming-convention shadowing-abstract.
    uint256[LAYOUT_LENGTH - 5] private __endGap; // __endGap complements layout to LAYOUT_LENGTH.
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/interfaces/MForcedTradeActionState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MForcedTradeActionState {
    function forcedTradeActionHash(
        uint256 starkKeyA,
        uint256 starkKeyB,
        uint256 vaultIdA,
        uint256 vaultIdB,
        uint256 collateralAssetId,
        uint256 syntheticAssetId,
        uint256 amountCollateral,
        uint256 amountSynthetic,
        bool aIsBuyingSynthetic,
        uint256 nonce
    ) internal pure virtual returns (bytes32);

    function clearForcedTradeRequest(
        uint256 starkKeyA,
        uint256 starkKeyB,
        uint256 vaultIdA,
        uint256 vaultIdB,
        uint256 collateralAssetId,
        uint256 syntheticAssetId,
        uint256 amountCollateral,
        uint256 amountSynthetic,
        bool aIsBuyingSynthetic,
        uint256 nonce
    ) internal virtual;

    // NOLINTNEXTLINE: external-function.
    function getForcedTradeRequest(
        uint256 starkKeyA,
        uint256 starkKeyB,
        uint256 vaultIdA,
        uint256 vaultIdB,
        uint256 collateralAssetId,
        uint256 syntheticAssetId,
        uint256 amountCollateral,
        uint256 amountSynthetic,
        bool aIsBuyingSynthetic,
        uint256 nonce
    ) public view virtual returns (uint256 res);

    function setForcedTradeRequest(
        uint256 starkKeyA,
        uint256 starkKeyB,
        uint256 vaultIdA,
        uint256 vaultIdB,
        uint256 collateralAssetId,
        uint256 syntheticAssetId,
        uint256 amountCollateral,
        uint256 amountSynthetic,
        bool aIsBuyingSynthetic,
        uint256 nonce,
        bool premiumCost
    ) internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/interfaces/MForcedWithdrawalActionState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MForcedWithdrawalActionState {
    function forcedWithdrawActionHash(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount
    ) internal pure virtual returns (bytes32);

    function clearForcedWithdrawalRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount
    ) internal virtual;

    // NOLINTNEXTLINE: external-function.
    function getForcedWithdrawalRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount
    ) public view virtual returns (uint256 res);

    function setForcedWithdrawalRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount,
        bool premiumCost
    ) internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/libraries/LibConstants.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract LibConstants {
    // Durations for time locked mechanisms (in seconds).
    // Note that it is known that miners can manipulate block timestamps
    // up to a deviation of a few seconds.
    // This mechanism should not be used for fine grained timing.

    // The time required to cancel a deposit, in the case the operator does not move the funds
    // to the off-chain storage.
    uint256 public constant DEPOSIT_CANCEL_DELAY = 2 days;

    // The time required to freeze the exchange, in the case the operator does not execute a
    // requested full withdrawal.
    uint256 public constant FREEZE_GRACE_PERIOD = 7 days;

    // The time after which the exchange may be unfrozen after it froze. This should be enough time
    // for users to perform escape hatches to get back their funds.
    uint256 public constant UNFREEZE_DELAY = 365 days;

    // Maximal number of verifiers which may co-exist.
    uint256 public constant MAX_VERIFIER_COUNT = uint256(64);

    // The time required to remove a verifier in case of a verifier upgrade.
    uint256 public constant VERIFIER_REMOVAL_DELAY = FREEZE_GRACE_PERIOD + (21 days);

    address constant ZERO_ADDRESS = address(0x0);

    uint256 constant K_MODULUS = 0x800000000000011000000000000000000000000000000000000000000000001;

    uint256 constant K_BETA = 0x6f21413efbe40de150e596d72f7a8c5609ad26c15c915c1f4cdfcb99cee9e89;

    uint256 internal constant MASK_250 =
        0x03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    uint256 internal constant MASK_240 =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    uint256 public constant MAX_FORCED_ACTIONS_REQS_PER_BLOCK = 10;

    uint256 constant QUANTUM_UPPER_BOUND = 2**128;
    uint256 internal constant MINTABLE_ASSET_ID_FLAG = 1 << 250;

    // The 64th bit (indexed 63, counting from 0) is a flag indicating a rollup vault id.
    uint256 constant ROLLUP_VAULTS_BIT = 63;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/PerpetualConstants.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract PerpetualConstants is LibConstants {
    uint256 constant PERPETUAL_POSITION_ID_UPPER_BOUND = 2**64;
    uint256 constant PERPETUAL_AMOUNT_UPPER_BOUND = 2**64;
    uint256 constant PERPETUAL_TIMESTAMP_BITS = 32;
    uint256 constant PERPETUAL_ASSET_ID_UPPER_BOUND = 2**120;
    uint256 constant PERPETUAL_SYSTEM_TIME_LAG_BOUND = 7 days;
    uint256 constant PERPETUAL_SYSTEM_TIME_ADVANCE_BOUND = 4 hours;
    uint256 constant PERPETUAL_CONFIGURATION_DELAY = 0;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/ProgramOutputOffsets.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract ProgramOutputOffsets {
    // The following constants are offsets of data expected in the program output.
    // The offsets here are of the fixed fields.
    uint256 internal constant PROG_OUT_GENERAL_CONFIG_HASH = 0;
    uint256 internal constant PROG_OUT_N_ASSET_CONFIGS = 1;
    uint256 internal constant PROG_OUT_ASSET_CONFIG_HASHES = 2;

    /*
      Additional mandatory fields of a single word:
      - Previous state size         2
      - New state size              3
      - Vault tree height           4
      - Order tree height           5
      - Expiration timestamp        6
      - No. of Modifications        7.
    */
    uint256 internal constant PROG_OUT_N_WORDS_MIN_SIZE = 8;

    uint256 internal constant PROG_OUT_N_WORDS_PER_ASSET_CONFIG = 2;
    uint256 internal constant PROG_OUT_N_WORDS_PER_MODIFICATION = 3;

    uint256 internal constant ASSET_CONFIG_OFFSET_ASSET_ID = 0;
    uint256 internal constant ASSET_CONFIG_OFFSET_CONFIG_HASH = 1;

    uint256 internal constant MODIFICATIONS_OFFSET_STARKKEY = 0;
    uint256 internal constant MODIFICATIONS_OFFSET_POS_ID = 1;
    uint256 internal constant MODIFICATIONS_OFFSET_BIASED_DIFF = 2;

    uint256 internal constant STATE_OFFSET_VAULTS_ROOT = 0;
    uint256 internal constant STATE_OFFSET_VAULTS_HEIGHT = 1;
    uint256 internal constant STATE_OFFSET_ORDERS_ROOT = 2;
    uint256 internal constant STATE_OFFSET_ORDERS_HEIGHT = 3;
    uint256 internal constant STATE_OFFSET_N_FUNDING = 4;
    uint256 internal constant STATE_OFFSET_FUNDING = 5;

    // The following constants are offsets of data expected in the application data.
    uint256 internal constant APP_DATA_BATCH_ID_OFFSET = 0;
    uint256 internal constant APP_DATA_PREVIOUS_BATCH_ID_OFFSET = 1;
    uint256 internal constant APP_DATA_N_CONDITIONAL_TRANSFER = 2;
    uint256 internal constant APP_DATA_CONDITIONAL_TRANSFER_DATA_OFFSET = 3;
    uint256 internal constant APP_DATA_N_WORDS_PER_CONDITIONAL_TRANSFER = 2;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/OnchainDataFactTreeEncoder.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

library OnchainDataFactTreeEncoder {
    struct DataAvailabilityFact {
        uint256 onchainDataHash;
        uint256 onchainDataSize;
    }

    // The number of additional words appended to the public input when using the
    // OnchainDataFactTreeEncoder format.
    uint256 internal constant ONCHAIN_DATA_FACT_ADDITIONAL_WORDS = 2;

    /*
      Encodes a GPS fact Merkle tree where the root has two children.
      The left child contains the data we care about and the right child contains
      on-chain data for the fact.
    */
    function encodeFactWithOnchainData(
        uint256[] calldata programOutput,
        DataAvailabilityFact memory factData
    ) internal pure returns (bytes32) {
        // The state transition fact is computed as a Merkle tree, as defined in
        // GpsOutputParser.
        //
        // In our case the fact tree looks as follows:
        //   The root has two children.
        //   The left child is a leaf that includes the main part - the information regarding
        //   the state transition required by this contract.
        //   The right child contains the onchain-data which shouldn't be accessed by this
        //   contract, so we are only given its hash and length
        //   (it may be a leaf or an inner node, this has no effect on this contract).

        // Compute the hash without the two additional fields.
        uint256 mainPublicInputLen = programOutput.length;
        bytes32 mainPublicInputHash = keccak256(abi.encodePacked(programOutput));

        // Compute the hash of the fact Merkle tree.
        bytes32 hashResult = keccak256(
            abi.encodePacked(
                mainPublicInputHash,
                mainPublicInputLen,
                factData.onchainDataHash,
                mainPublicInputLen + factData.onchainDataSize
            )
        );
        // Add one to the hash to indicate it represents an inner node, rather than a leaf.
        return bytes32(uint256(hashResult) + 1);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/IFactRegistry.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  The Fact Registry design pattern is a way to separate cryptographic verification from the
  business logic of the contract flow.

  A fact registry holds a hash table of verified "facts" which are represented by a hash of claims
  that the registry hash check and found valid. This table may be queried by accessing the
  isValid() function of the registry with a given hash.

  In addition, each fact registry exposes a registry specific function for submitting new claims
  together with their proofs. The information submitted varies from one registry to the other
  depending of the type of fact requiring verification.

  For further reading on the Fact Registry design pattern see this
  `StarkWare blog post <https://medium.com/starkware/the-fact-registry-a64aafb598b6>`_.
*/
interface IFactRegistry {
    /*
      Returns true if the given fact was previously registered in the contract.
    */
    function isValid(bytes32 fact) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/VerifyFactChain.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;



contract VerifyFactChain is MainStorage {
    function verifyFact(
        StarkExTypes.ApprovalChainData storage chain,
        bytes32 fact,
        string memory noVerifiersErrorMessage,
        string memory invalidFactErrorMessage
    ) internal view {
        address[] storage list = chain.list;
        uint256 n_entries = list.length;
        require(n_entries > 0, noVerifiersErrorMessage);
        for (uint256 i = 0; i < n_entries; i++) {
            // NOLINTNEXTLINE: calls-loop.
            require(IFactRegistry(list[i]).isValid(fact), invalidFactErrorMessage);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MAcceptModifications.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Interface containing actions a verifier can invoke on the state.
  The contract containing the state should implement these and verify correctness.
*/
abstract contract MAcceptModifications {
    function acceptDeposit(
        uint256 ownerKey,
        uint256 vaultId,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal virtual;

    function allowWithdrawal(
        uint256 ownerKey,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal virtual;

    function acceptWithdrawal(
        uint256 ownerKey,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MFreezable.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MFreezable {
    /*
      Returns true if the exchange is frozen.
    */
    function isFrozen() public view virtual returns (bool); // NOLINT: external-function.

    /*
      Forbids calling the function if the exchange is frozen.
    */
    modifier notFrozen() {
        require(!isFrozen(), "STATE_IS_FROZEN");
        _;
    }

    function validateFreezeRequest(uint256 requestTime) internal virtual;

    /*
      Allows calling the function only if the exchange is frozen.
    */
    modifier onlyFrozen() {
        require(isFrozen(), "STATE_NOT_FROZEN");
        _;
    }

    /*
      Freezes the exchange.
    */
    function freeze() internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MOperator.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MOperator {
    event LogOperatorAdded(address operator);
    event LogOperatorRemoved(address operator);

    function isOperator(address testedOperator) public view virtual returns (bool);

    modifier onlyOperator() {
        require(isOperator(msg.sender), "ONLY_OPERATOR");
        _;
    }

    function registerOperator(address newOperator) external virtual;

    function unregisterOperator(address removedOperator) external virtual;

    function getOperators() internal view virtual returns (mapping(address => bool) storage);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/components/UpdatePerpetualState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;











/**
  TO-DO:DOC.
*/
abstract contract UpdatePerpetualState is
    PerpetualStorage,
    PerpetualConstants,
    MForcedTradeActionState,
    MForcedWithdrawalActionState,
    VerifyFactChain,
    MAcceptModifications,
    MFreezable,
    MOperator,
    ProgramOutputOffsets
{
    event LogUpdateState(uint256 sequenceNumber, uint256 batchId);

    event LogStateTransitionFact(bytes32 stateTransitionFact);

    enum ForcedAction {
        Withdrawal,
        Trade
    }

    struct ProgramOutputMarkers {
        uint256 globalConfigurationHash;
        uint256 nAssets;
        uint256 assetConfigOffset;
        uint256 prevSharedStateSize;
        uint256 prevSharedStateOffset;
        uint256 newSharedStateSize;
        uint256 newSharedStateOffset;
        uint256 newSystemTime;
        uint256 expirationTimestamp;
        uint256 nModifications;
        uint256 modificationsOffset;
        uint256 forcedActionsSize;
        uint256 nForcedActions;
        uint256 forcedActionsOffset;
        uint256 nConditions;
        uint256 conditionsOffset;
    }

    function updateState(uint256[] calldata programOutput, uint256[] calldata applicationData)
        external
        notFrozen
        onlyOperator
    {
        ProgramOutputMarkers memory outputMarkers = parseProgramOutput(programOutput);
        require(
            outputMarkers.expirationTimestamp < 2**PERPETUAL_TIMESTAMP_BITS,
            "Expiration timestamp is out of range."
        );

        require(
            outputMarkers.newSystemTime > (block.timestamp - PERPETUAL_SYSTEM_TIME_LAG_BOUND),
            "SYSTEM_TIME_OUTDATED"
        );

        require(
            outputMarkers.newSystemTime < (block.timestamp + PERPETUAL_SYSTEM_TIME_ADVANCE_BOUND),
            "SYSTEM_TIME_INVALID"
        );

        require(
            outputMarkers.expirationTimestamp > block.timestamp / 3600,
            "BATCH_TIMESTAMP_EXPIRED"
        );

        validateConfigHashes(programOutput, outputMarkers);

        // Caclulate previous shared state hash, and compare with stored one.
        bytes32 prevStateHash = keccak256(
            abi.encodePacked(
                programOutput[outputMarkers.prevSharedStateOffset:outputMarkers
                    .prevSharedStateOffset + outputMarkers.prevSharedStateSize]
            )
        );

        require(prevStateHash == sharedStateHash, "INVALID_PREVIOUS_SHARED_STATE");

        require(
            applicationData[APP_DATA_PREVIOUS_BATCH_ID_OFFSET] == lastBatchId,
            "WRONG_PREVIOUS_BATCH_ID"
        );

        require(
            programOutput.length >=
                outputMarkers.forcedActionsOffset +
                    OnchainDataFactTreeEncoder.ONCHAIN_DATA_FACT_ADDITIONAL_WORDS,
            "programOutput does not contain all required fields."
        );
        bytes32 stateTransitionFact = OnchainDataFactTreeEncoder.encodeFactWithOnchainData(
            programOutput[:programOutput.length -
                OnchainDataFactTreeEncoder.ONCHAIN_DATA_FACT_ADDITIONAL_WORDS],
            OnchainDataFactTreeEncoder.DataAvailabilityFact({
                onchainDataHash: programOutput[programOutput.length - 2],
                onchainDataSize: programOutput[programOutput.length - 1]
            })
        );

        emit LogStateTransitionFact(stateTransitionFact);

        verifyFact(
            verifiersChain,
            stateTransitionFact,
            "NO_STATE_TRANSITION_VERIFIERS",
            "NO_STATE_TRANSITION_PROOF"
        );

        performUpdateState(programOutput, outputMarkers, applicationData);
    }

    function validateConfigHashes(
        uint256[] calldata programOutput,
        ProgramOutputMarkers memory markers
    ) internal view {
        require(globalConfigurationHash != bytes32(0), "GLOBAL_CONFIGURATION_NOT_SET");
        require(
            globalConfigurationHash == bytes32(markers.globalConfigurationHash),
            "GLOBAL_CONFIGURATION_MISMATCH"
        );

        uint256 offset = markers.assetConfigOffset;
        for (uint256 i = 0; i < markers.nAssets; i++) {
            uint256 assetId = programOutput[offset + ASSET_CONFIG_OFFSET_ASSET_ID];
            bytes32 assetConfigHash = bytes32(
                programOutput[offset + ASSET_CONFIG_OFFSET_CONFIG_HASH]
            );
            require(configurationHash[assetId] == assetConfigHash, "ASSET_CONFIGURATION_MISMATCH");
            offset += PROG_OUT_N_WORDS_PER_ASSET_CONFIG;
        }
    }

    function parseProgramOutput(uint256[] calldata programOutput)
        internal
        pure
        returns (ProgramOutputMarkers memory)
    {
        require(
            programOutput.length >= PROG_OUT_N_WORDS_MIN_SIZE,
            "programOutput does not contain all required fields."
        );

        ProgramOutputMarkers memory markers; // NOLINT: uninitialized-local.
        markers.globalConfigurationHash = programOutput[PROG_OUT_GENERAL_CONFIG_HASH];
        markers.nAssets = programOutput[PROG_OUT_N_ASSET_CONFIGS];
        require(markers.nAssets < 2**16, "ILLEGAL_NUMBER_OF_ASSETS");

        uint256 offset = PROG_OUT_ASSET_CONFIG_HASHES;
        markers.assetConfigOffset = offset;
        offset += markers.nAssets * PROG_OUT_N_WORDS_PER_ASSET_CONFIG;
        require(
            programOutput.length >= offset + 1, // Adding +1 for the next mandatory field.
            "programOutput invalid size (nAssetConfig)"
        );

        markers.prevSharedStateSize = programOutput[offset++];
        markers.prevSharedStateOffset = offset;

        offset += markers.prevSharedStateSize;
        require(
            programOutput.length >= offset + 1, // Adding +1 for the next mandatory field.
            "programOutput invalid size (prevState)"
        );

        markers.newSharedStateSize = programOutput[offset++];
        markers.newSharedStateOffset = offset;

        offset += markers.newSharedStateSize;
        require(
            programOutput.length >= offset + 2, // Adding +2 for the next mandatory fields.
            "programOutput invalid size (newState)"
        );

        // System time is the last field in the state.
        markers.newSystemTime = programOutput[offset - 1];

        markers.expirationTimestamp = programOutput[offset++];

        markers.nModifications = programOutput[offset++];
        markers.modificationsOffset = offset;
        offset += markers.nModifications * PROG_OUT_N_WORDS_PER_MODIFICATION;

        markers.forcedActionsSize = programOutput[offset++];
        markers.nForcedActions = programOutput[offset++];
        markers.forcedActionsOffset = offset;
        offset += markers.forcedActionsSize;

        markers.nConditions = programOutput[offset++];
        markers.conditionsOffset = offset;
        offset += markers.nConditions;

        offset += OnchainDataFactTreeEncoder.ONCHAIN_DATA_FACT_ADDITIONAL_WORDS;

        require(
            programOutput.length == offset,
            "programOutput invalid size (mods/forced/conditions)"
        );
        return markers;
    }

    function performUpdateState(
        uint256[] calldata programOutput,
        ProgramOutputMarkers memory markers,
        uint256[] calldata applicationData
    ) internal {
        sharedStateHash = keccak256(
            abi.encodePacked(
                programOutput[markers.newSharedStateOffset:markers.newSharedStateOffset +
                    markers.newSharedStateSize]
            )
        );

        sequenceNumber += 1;
        uint256 batchId = applicationData[APP_DATA_BATCH_ID_OFFSET];
        lastBatchId = batchId;

        sendModifications(programOutput, markers, applicationData);

        verifyConditionalTransfers(programOutput, markers, applicationData);

        clearForcedActionsFlags(programOutput, markers);

        emit LogUpdateState(sequenceNumber, batchId);
    }

    /*
      Goes through the program output forced actions section,
      extract each forced action, and if valid and its flag exists, clears it.
      If invalid, or not flag not exist - revert.
    */
    function clearForcedActionsFlags(
        uint256[] calldata programOutput,
        ProgramOutputMarkers memory markers
    ) private {
        uint256 offset = markers.forcedActionsOffset;
        for (uint256 i = 0; i < markers.nForcedActions; i++) {
            ForcedAction forcedActionType = ForcedAction(programOutput[offset++]);
            if (forcedActionType == ForcedAction.Withdrawal) {
                offset = clearForcedWithdrawal(programOutput, offset);
            } else if (forcedActionType == ForcedAction.Trade) {
                offset = clearForcedTrade(programOutput, offset);
            } else {
                revert("UNKNOWN_FORCED_ACTION_TYPE");
            }
        }
        // Ensure all sizes are matching (this is not checked in parsing).
        require(markers.forcedActionsOffset + markers.forcedActionsSize == offset, "SIZE_MISMATCH");
    }

    function clearForcedWithdrawal(uint256[] calldata programOutput, uint256 offset)
        private
        returns (uint256)
    {
        uint256 starkKey = programOutput[offset++];
        uint256 vaultId = programOutput[offset++];
        uint256 quantizedAmount = programOutput[offset++];
        clearForcedWithdrawalRequest(starkKey, vaultId, quantizedAmount);
        return offset;
    }

    function clearForcedTrade(uint256[] calldata programOutput, uint256 offset)
        private
        returns (uint256)
    {
        uint256 starkKeyA = programOutput[offset++];
        uint256 starkKeyB = programOutput[offset++];
        uint256 vaultIdA = programOutput[offset++];
        uint256 vaultIdB = programOutput[offset++];
        // CollateralAssetId Not taken from progOutput. We use systemAssetType.
        uint256 syntheticAssetId = programOutput[offset++];
        uint256 amountCollateral = programOutput[offset++];
        uint256 amountSynthetic = programOutput[offset++];
        bool aIsBuyingSynthetic = (programOutput[offset++] != 0);
        uint256 nonce = programOutput[offset++];
        clearForcedTradeRequest(
            starkKeyA,
            starkKeyB,
            vaultIdA,
            vaultIdB,
            systemAssetType,
            syntheticAssetId,
            amountCollateral,
            amountSynthetic,
            aIsBuyingSynthetic,
            nonce
        );
        return offset;
    }

    function verifyConditionalTransfers(
        uint256[] calldata programOutput,
        ProgramOutputMarkers memory markers,
        uint256[] calldata applicationData
    ) private view {
        require(applicationData.length >= APP_DATA_N_CONDITIONAL_TRANSFER, "APP_DATA_TOO_SHORT");

        require(
            applicationData[APP_DATA_N_CONDITIONAL_TRANSFER] == markers.nConditions,
            "N_CONDITIONS_MISMATCH"
        );

        require(
            applicationData.length >=
                APP_DATA_CONDITIONAL_TRANSFER_DATA_OFFSET +
                    markers.nConditions *
                    APP_DATA_N_WORDS_PER_CONDITIONAL_TRANSFER,
            "BAD_APP_DATA_SIZE"
        );

        uint256 conditionsOffset = markers.conditionsOffset;
        uint256 preImageOffset = APP_DATA_CONDITIONAL_TRANSFER_DATA_OFFSET;

        // Conditional Transfers appear after all other modifications.
        for (uint256 i = 0; i < markers.nConditions; i++) {
            address transferRegistry = address(applicationData[preImageOffset]);
            bytes32 transferFact = bytes32(applicationData[preImageOffset + 1]);
            uint256 condition = programOutput[conditionsOffset];

            // The condition is the 250 LS bits of keccak256 of the fact registry & fact.
            require(
                condition ==
                    uint256(keccak256(abi.encodePacked(transferRegistry, transferFact))) & MASK_250,
                "Condition mismatch."
            );
            // NOLINTNEXTLINE: low-level-calls-loop reentrancy-events.
            (bool success, bytes memory returndata) = transferRegistry.staticcall(
                abi.encodeWithSignature("isValid(bytes32)", transferFact)
            );
            require(success && returndata.length == 32, "BAD_FACT_REGISTRY_CONTRACT");
            require(
                abi.decode(returndata, (bool)),
                "Condition for the conditional transfer was not met."
            );
            conditionsOffset += 1;
            preImageOffset += APP_DATA_N_WORDS_PER_CONDITIONAL_TRANSFER;
        }
    }

    function sendModifications(
        uint256[] calldata programOutput,
        ProgramOutputMarkers memory markers,
        uint256[] calldata /*applicationData*/
    ) private {
        uint256 assetId = systemAssetType;
        require(assetId < K_MODULUS, "Asset id >= PRIME");

        uint256 offset = markers.modificationsOffset;
        for (uint256 i = 0; i < markers.nModifications; i++) {
            uint256 starkKey = programOutput[offset + MODIFICATIONS_OFFSET_STARKKEY];
            uint256 vaultId = programOutput[offset + MODIFICATIONS_OFFSET_POS_ID];
            uint256 biasedDiff = programOutput[offset + MODIFICATIONS_OFFSET_BIASED_DIFF];
            // Biased representation.
            // biased_delta is in range [0, 2**65), where 2**64 means 0 change.
            // The effective difference is biased_delta - 2**64.
            require(biasedDiff < (1 << 65), "Illegal Balance Diff");
            int256 balanceDiff = int256(biasedDiff - (1 << 64));

            require(starkKey < K_MODULUS, "Stark key >= PRIME");

            if (balanceDiff > 0) {
                // This is a deposit.
                acceptDeposit(starkKey, vaultId, assetId, uint256(balanceDiff));
            } else if (balanceDiff < 0) {
                // This is a withdrawal.
                acceptWithdrawal(starkKey, assetId, uint256(-balanceDiff));
            }
            offset += PROG_OUT_N_WORDS_PER_MODIFICATION;
        }
    }
}
