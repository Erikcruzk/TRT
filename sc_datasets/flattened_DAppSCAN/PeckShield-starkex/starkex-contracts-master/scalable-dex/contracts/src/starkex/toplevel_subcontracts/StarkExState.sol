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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MStateRoot.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MStateRoot {
    function getValidiumVaultRoot() public view virtual returns (uint256);

    function getValidiumTreeHeight() public view virtual returns (uint256);

    function getRollupVaultRoot() public view virtual returns (uint256);

    function getRollupTreeHeight() public view virtual returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/components/Escapes.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;






/**
  Escaping the exchange is the last resort for users that wish to withdraw their funds without
  relying on off-chain exchange services. The Escape functionality may only be invoked once the
  contract has become frozen. This will be as the result of an unserviced full withdraw request
  (see :sol:mod:`FullWithdrawals`). At that point, any escaper entity may perform an escape
  operation as follows:

  1. Escapers must obtain a Merkle path of a vault leaf to be evicted with respect to the frozen vault tree root. There are two vault trees: a validium vaults tree and a rollup vaults tree. Rollup vaults data can always be reconstructed from on-chain data. Typically, once the exchange is frozen, validium vaults data will be made public or would be obtainable from an exchange API, depending on the data availability approach used by the exchange.
  2. Escapers call the :sol:mod:`EscapeVerifier` contract with the Merkle proof for the vault to be evicted. The leaf index for the escape verifier can be computed from the vaultId by clearing the ROLLUP_VAULTS_BIT bit. If the proof is valid, this results in the registration of such proof.
  3. Escapers call :sol:func:`escape` function with the parameters that constituted the escapeProof submitted to the :sol:mod:`EscapeVerifier` (i.e. the Public Key of the vault owner, full vault ID, asset ID and vault balance). If a proof was accepted for those parameters by the :sol:mod:`EscapeVerifier`, and no prior escape call was made for the vault, the contract adds the vault balance to an on-chain pending withdrawals account under the Public Key of the vault owner and the appropriate asset ID.
  4. The owner of the vault may then withdraw this amount from the pending withdrawals account by calling the normal withdraw function (see :sol:mod:`Withdrawals`) to transfer the funds to the users Eth or ERC20 account (depending on the token type).

  Note that while anyone can perform the initial steps of the escape operation (including the
  exchange operator, for example), only the owner of the vault may perform the final step of
  transferring the funds.
*/
abstract contract Escapes is
    MainStorage,
    LibConstants,
    MAcceptModifications,
    MFreezable,
    MStateRoot
{
    function initialize(address escapeVerifier) internal {
        escapeVerifierAddress = escapeVerifier;
    }

    function isRollupVault(uint256 vaultId) internal pure returns (bool) {
        return (vaultId >> ROLLUP_VAULTS_BIT) != 0;
    }

    /*
      Escape when the contract is frozen.
    */
    function escape(
        uint256 ownerKey,
        uint256 vaultId,
        uint256 assetId,
        uint256 quantizedAmount
    ) external onlyFrozen {
        require(!escapesUsed[vaultId], "ESCAPE_ALREADY_USED");

        // Escape can be used only once.
        escapesUsed[vaultId] = true;
        escapesUsedCount += 1;

        // Select a vault tree to escape from, based on the vault id.
        (uint256 root, uint256 treeHeight) = isRollupVault(vaultId)
            ? (getRollupVaultRoot(), getRollupTreeHeight())
            : (getValidiumVaultRoot(), getValidiumTreeHeight());

        // The index of vaultId leaf in its tree doesn't include the rollup bit flag.
        uint256 vaultLeafIndex = (vaultId & (2**ROLLUP_VAULTS_BIT - 1));

        bytes32 claimHash = keccak256(
            abi.encode(ownerKey, assetId, quantizedAmount, root, treeHeight, vaultLeafIndex)
        );
        IFactRegistry escapeVerifier = IFactRegistry(escapeVerifierAddress);
        require(escapeVerifier.isValid(claimHash), "ESCAPE_LACKS_PROOF");

        allowWithdrawal(ownerKey, assetId, quantizedAmount);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/components/StarkExStorage.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Extends MainStorage, holds StarkEx App specific state (storage) variables.

  ALL State variables that are common to all applications, reside in MainStorage,
  whereas ALL the StarkEx app specific ones reside here.
*/
contract StarkExStorage is MainStorage {
    // Onchain vaults balances.
    // A map eth_address => asset_id => vault_id => quantized amount.
    mapping(address => mapping(uint256 => mapping(uint256 => uint256))) vaultsBalances;

    // Onchain vaults withdrawal lock time.
    // A map eth_address => asset_id => vault_id => lock expiration timestamp.
    mapping(address => mapping(uint256 => mapping(uint256 => uint256))) vaultsWithdrawalLocks;

    // Enforces the minimal balance requirement (as output by Cairo) on onchain vault updates.
    // When disabled, flash loans are enabled.
    bool strictVaultBalancePolicy; // NOLINT: constable-states, uninitialized-state.

    // The default time, in seconds, that an onchain vault is locked for withdrawal after a deposit.
    uint256 public defaultVaultWithdrawalLock; // NOLINT: constable-states.

    // Address of the message registry contract that is used to sign and verify L1 orders.
    address public orderRegistryAddress; // NOLINT: constable-states.

    // Reserved storage space for Extensibility.
    // Every added MUST be added above the end gap, and the __endGap size must be reduced
    // accordingly.
    // NOLINTNEXTLINE: naming-convention shadowing-abstract.
    uint256[LAYOUT_LENGTH - 5] private __endGap; // __endGap complements layout to LAYOUT_LENGTH.
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/interfaces/MStarkExForcedActionState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MStarkExForcedActionState {
    function fullWithdrawActionHash(uint256 ownerKey, uint256 vaultId)
        internal
        pure
        virtual
        returns (bytes32);

    function clearFullWithdrawalRequest(uint256 ownerKey, uint256 vaultId) internal virtual;

    // NOLINTNEXTLINE: external-function.
    function getFullWithdrawalRequest(uint256 ownerKey, uint256 vaultId)
        public
        view
        virtual
        returns (uint256);

    function setFullWithdrawalRequest(uint256 ownerKey, uint256 vaultId) internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/ActionHash.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


/*
  Calculation action hash for the various forced actions in a generic manner.
*/
contract ActionHash is MainStorage, LibConstants {
    function getActionHash(string memory actionName, bytes memory packedActionParameters)
        internal
        pure
        returns (bytes32 actionHash)
    {
        actionHash = keccak256(abi.encodePacked(actionName, packedActionParameters));
    }

    function setActionHash(bytes32 actionHash, bool premiumCost) internal {
        // The rate of forced trade requests is restricted.
        // First restriction is by capping the number of requests in a block.
        // User can override this cap by requesting with a permium flag set,
        // in this case, the gas cost is high (~1M) but no "technical" limit is set.
        // However, the high gas cost creates an obvious limitation due to the block gas limit.
        if (premiumCost) {
            for (uint256 i = 0; i < 21129; i++) {}
        } else {
            require(
                forcedRequestsInBlock[block.number] < MAX_FORCED_ACTIONS_REQS_PER_BLOCK,
                "MAX_REQUESTS_PER_BLOCK_REACHED"
            );
            forcedRequestsInBlock[block.number] += 1;
        }
        forcedActionRequests[actionHash] = block.timestamp;
        actionHashList.push(actionHash);
    }

    function getActionCount() external view returns (uint256) {
        return actionHashList.length;
    }

    function getActionHashByIndex(uint256 actionIndex) external view returns (bytes32) {
        require(actionIndex < actionHashList.length, "ACTION_INDEX_TOO_HIGH");
        return actionHashList[actionIndex];
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/interactions/StarkExForcedActionState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;



/*
  StarkExchange specific action hashses.
*/
contract StarkExForcedActionState is StarkExStorage, ActionHash, MStarkExForcedActionState {
    function fullWithdrawActionHash(uint256 ownerKey, uint256 vaultId)
        internal
        pure
        override
        returns (bytes32)
    {
        return getActionHash("FULL_WITHDRAWAL", abi.encode(ownerKey, vaultId));
    }

    /*
      Implemented in the FullWithdrawal contracts.
    */
    function clearFullWithdrawalRequest(uint256 ownerKey, uint256 vaultId)
        internal
        virtual
        override
    {
        // Reset escape request.
        delete forcedActionRequests[fullWithdrawActionHash(ownerKey, vaultId)];
    }

    function getFullWithdrawalRequest(uint256 ownerKey, uint256 vaultId)
        public
        view
        override
        returns (uint256)
    {
        // Return request value. Expect zero if the request doesn't exist or has been serviced, and
        // a non-zero value otherwise.
        return forcedActionRequests[fullWithdrawActionHash(ownerKey, vaultId)];
    }

    function setFullWithdrawalRequest(uint256 ownerKey, uint256 vaultId) internal override {
        // FullWithdrawal is always at premium cost, hence the `true`.
        setActionHash(fullWithdrawActionHash(ownerKey, vaultId), true);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/PublicInputOffsets.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract PublicInputOffsets {
    // The following constants are offsets of data expected in the public input.
    uint256 internal constant PUB_IN_GLOBAL_CONFIG_CODE_OFFSET = 0;
    uint256 internal constant PUB_IN_INITIAL_VALIDIUM_VAULT_ROOT_OFFSET = 1;
    uint256 internal constant PUB_IN_FINAL_VALIDIUM_VAULT_ROOT_OFFSET = 2;
    uint256 internal constant PUB_IN_INITIAL_ROLLUP_VAULT_ROOT_OFFSET = 3;
    uint256 internal constant PUB_IN_FINAL_ROLLUP_VAULT_ROOT_OFFSET = 4;
    uint256 internal constant PUB_IN_INITIAL_ORDER_ROOT_OFFSET = 5;
    uint256 internal constant PUB_IN_FINAL_ORDER_ROOT_OFFSET = 6;
    uint256 internal constant PUB_IN_GLOBAL_EXPIRATION_TIMESTAMP_OFFSET = 7;
    uint256 internal constant PUB_IN_VALIDIUM_VAULT_TREE_HEIGHT_OFFSET = 8;
    uint256 internal constant PUB_IN_ROLLUP_VAULT_TREE_HEIGHT_OFFSET = 9;
    uint256 internal constant PUB_IN_ORDER_TREE_HEIGHT_OFFSET = 10;
    uint256 internal constant PUB_IN_N_MODIFICATIONS_OFFSET = 11;
    uint256 internal constant PUB_IN_N_CONDITIONAL_TRANSFERS_OFFSET = 12;
    uint256 internal constant PUB_IN_N_ONCHAIN_VAULT_UPDATES_OFFSET = 13;
    uint256 internal constant PUB_IN_N_ONCHAIN_ORDERS_OFFSET = 14;
    uint256 internal constant PUB_IN_TRANSACTIONS_DATA_OFFSET = 15;

    uint256 internal constant PUB_IN_N_WORDS_PER_MODIFICATION = 3;
    uint256 internal constant PUB_IN_N_WORDS_PER_CONDITIONAL_TRANSFER = 1;
    uint256 internal constant PUB_IN_N_WORDS_PER_ONCHAIN_VAULT_UPDATE = 3;
    uint256 internal constant PUB_IN_N_MIN_WORDS_PER_ONCHAIN_ORDER = 3;

    // The following constants are offsets of data expected in the application data.
    uint256 internal constant APP_DATA_BATCH_ID_OFFSET = 0;
    uint256 internal constant APP_DATA_PREVIOUS_BATCH_ID_OFFSET = 1;
    uint256 internal constant APP_DATA_TRANSACTIONS_DATA_OFFSET = 2;

    uint256 internal constant APP_DATA_N_WORDS_PER_CONDITIONAL_TRANSFER = 2;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/StarkExConstants.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract StarkExConstants is LibConstants {
    uint256 constant STARKEX_EXPIRATION_TIMESTAMP_BITS = 22;
    uint256 public constant STARKEX_MAX_DEFAULT_VAULT_LOCK = 7 days;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/Identity.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

interface Identity {
    /*
      Allows a caller, typically another contract,
      to ensure that the provided address is of the expected type and version.
    */
    function identify() external pure returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/IQueryableFactRegistry.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Extends the IFactRegistry interface with a query method that indicates
  whether the fact registry has successfully registered any fact or is still empty of such facts.
*/
interface IQueryableFactRegistry is IFactRegistry {
    /*
      Returns true if at least one fact has been registered.
    */
    function hasRegisteredFact() external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/FactRegistry.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract FactRegistry is IQueryableFactRegistry {
    // Mapping: fact hash -> true.
    mapping(bytes32 => bool) private verifiedFact;

    // Indicates whether the Fact Registry has at least one fact registered.
    bool anyFactRegistered;

    /*
      Checks if a fact has been verified.
    */
    function isValid(bytes32 fact) external view override returns (bool) {
        return _factCheck(fact);
    }

    /*
      This is an internal method to check if the fact is already registered.
      In current implementation of FactRegistry it's identical to isValid().
      But the check is against the local fact registry,
      So for a derived referral fact registry, it's not the same.
    */
    function _factCheck(bytes32 fact) internal view returns (bool) {
        return verifiedFact[fact];
    }

    function registerFact(bytes32 factHash) internal {
        // This function stores the fact hash in the mapping.
        verifiedFact[factHash] = true;

        // Mark first time off.
        if (!anyFactRegistered) {
            anyFactRegistered = true;
        }
    }

    /*
      Indicates whether at least one fact was registered.
    */
    function hasRegisteredFact() external view override returns (bool) {
        return anyFactRegistered;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/MessageRegistry.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


contract MessageRegistry is FactRegistry, Identity {
    event LogMsgRegistered(address from, address to, bytes32 msgHash);

    function identify() external pure virtual override returns (string memory) {
        return "StarkWare_MessageRegistry_2021_1";
    }

    // NOLINTNEXTLINE: external-function.
    function registerMessage(address to, bytes32 messageHash) public {
        bytes32 messageFact = keccak256(abi.encodePacked(msg.sender, to, messageHash));
        registerFact(messageFact);
        emit LogMsgRegistered(msg.sender, to, messageHash);
    }

    function isMessageRegistered(
        address from,
        address to,
        bytes32 messageHash
    ) external view returns (bool) {
        bytes32 messageFact = keccak256(abi.encodePacked(from, to, messageHash));
        return _factCheck(messageFact);
    }
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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/interactions/UpdateState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;











/**
  The StarkEx contract tracks the state of the off-chain exchange service by storing Merkle roots
  of the vault state (off-chain account state) and the order state (including fully executed and
  partially fulfilled orders).

  The :sol:mod:`Operator` is the only entity entitled to submit state updates for a batch of
  exchange transactions by calling :sol:func:`updateState` and this is only allowed if the contract
  is not in the `frozen` state (see :sol:mod:`FullWithdrawals`). The call includes the `publicInput`
  of a STARK proof, and additional data (`applicationData`) that includes information not attested
  to by the proof.

  The `publicInput` includes the current (initial) and next (final) Merkle roots as mentioned above,
  the heights of the Merkle trees, a list of vault operations and a list of conditional transfers.

  A vault operation can be a ramping operation (deposit/withdrawal) or an indication to clear
  a full withdrawal request. Each vault operation is encoded in 3 words as follows:
  | 1. Word 0: Stark Key of the vault owner (or the requestor Stark Key for false full
  |    withdrawal).
  | 2. Word 1: Asset ID of the vault representing either the currency (for fungible tokens) or
  |    a unique token ID and its on-chain contract association (for non-fungible tokens).
  | 3. Word 2:
  |    a. ID of the vault (off-chain account)
  |    b. Vault balance change in biased representation (excess-2**63).
  |       A negative balance change implies a withdrawal while a positive amount implies a deposit.
  |       A zero balance change may be used for operations implying neither
  |       (e.g. a false full withdrawal request).
  |    c. A bit indicating whether the operation requires clearing a full withdrawal request.

  The above information is used by the exchange contract in order to update the pending accounts
  used for deposits (see :sol:mod:`Deposits`) and withdrawals (see :sol:mod:`Withdrawals`).

  The next section in the publicInput is a list of encoded conditions corresponding to the
  conditional transfers in the batch. A condition is encoded as a hash of the conditional transfer
  `applicationData`, described below, masked to 250 bits.

  The `applicationData` holds the following information:
  | 1. The ID of the current batch for which the operator is submitting the update.
  | 2. The expected ID of the last batch accepted on chain. This allows the operator submitting
  |    state updates to ensure the same batch order is accepted on-chain as was intended by the
  |    operator in the event that more than one valid update may have been generated based on
  |    different previous batches - an unlikely but possible event.
  | 3. For each conditional transfer in the batch two words are provided:
  |    a. Word 0: The address of a fact registry contract
  |    b. Word 1: A fact to be verified on the above contract attesting that the
  |       condition has been met on-chain.


  The following section in the publicInput is a list of orders to be verified onchain, corresponding
  to the onchain orders in the batch. An onchain order is of a variable length (at least 3 words)
  and is structured as follows:
  | 1. The Eth address of the user who submitted the order.
  | 2. The size (number of words) of the order blob that follows. Denoted 'n' below.
  | 3. First word of the order blob.
  | ...
  | n + 2. Last word of the order blob.

  The STARK proof attesting to the validity of the state update is submitted separately by the
  exchange service to (one or more) STARK integrity verifier contract(s).
  Likewise, the signatures of committee members attesting to
  the availability of the vault and order data is submitted separately by the exchange service to
  (one or more) availability verifier contract(s) (see :sol:mod:`Committee`).

  The state update is only accepted by the exchange contract if the integrity verifier and
  availability verifier contracts have indeed received such proof of soundness and data
  availability.
*/
abstract contract UpdateState is
    StarkExStorage,
    StarkExConstants,
    MStarkExForcedActionState,
    VerifyFactChain,
    MAcceptModifications,
    MFreezable,
    MOperator,
    PublicInputOffsets
{
    event LogRootUpdate(
        uint256 sequenceNumber,
        uint256 batchId,
        uint256 validiumVaultRoot,
        uint256 rollupVaultRoot,
        uint256 orderRoot
    );

    event LogStateTransitionFact(bytes32 stateTransitionFact);

    event LogVaultBalanceChangeApplied(
        address ethKey,
        uint256 assetId,
        uint256 vaultId,
        int256 quantizedAmountChange
    );

    function updateState(uint256[] calldata publicInput, uint256[] calldata applicationData)
        external
        virtual
        notFrozen
        onlyOperator
    {
        require(
            publicInput.length >= PUB_IN_TRANSACTIONS_DATA_OFFSET,
            "publicInput does not contain all required fields."
        );
        require(
            publicInput[PUB_IN_GLOBAL_CONFIG_CODE_OFFSET] == globalConfigCode,
            "Global config code mismatch."
        );
        require(
            publicInput[PUB_IN_FINAL_VALIDIUM_VAULT_ROOT_OFFSET] < K_MODULUS,
            "New validium vault root >= PRIME."
        );
        require(
            publicInput[PUB_IN_FINAL_ROLLUP_VAULT_ROOT_OFFSET] < K_MODULUS,
            "New rollup vault root >= PRIME."
        );
        require(
            publicInput[PUB_IN_FINAL_ORDER_ROOT_OFFSET] < K_MODULUS,
            "New order root >= PRIME."
        );
        require(
            lastBatchId == 0 || applicationData[APP_DATA_PREVIOUS_BATCH_ID_OFFSET] == lastBatchId,
            "WRONG_PREVIOUS_BATCH_ID"
        );

        // Ensure global timestamp has not expired.
        require(
            publicInput[PUB_IN_GLOBAL_EXPIRATION_TIMESTAMP_OFFSET] <
                2**STARKEX_EXPIRATION_TIMESTAMP_BITS,
            "Global expiration timestamp is out of range."
        );

        require( // NOLINT: block-timestamp.
            publicInput[PUB_IN_GLOBAL_EXPIRATION_TIMESTAMP_OFFSET] > block.timestamp / 3600,
            "Timestamp of the current block passed the threshold for the transaction batch."
        );

        bytes32 stateTransitionFact = getStateTransitionFact(publicInput);

        emit LogStateTransitionFact(stateTransitionFact);

        verifyFact(
            verifiersChain,
            stateTransitionFact,
            "NO_STATE_TRANSITION_VERIFIERS",
            "NO_STATE_TRANSITION_PROOF"
        );

        bytes32 availabilityFact = keccak256(
            abi.encodePacked(
                publicInput[PUB_IN_FINAL_VALIDIUM_VAULT_ROOT_OFFSET],
                publicInput[PUB_IN_VALIDIUM_VAULT_TREE_HEIGHT_OFFSET],
                publicInput[PUB_IN_FINAL_ORDER_ROOT_OFFSET],
                publicInput[PUB_IN_ORDER_TREE_HEIGHT_OFFSET],
                sequenceNumber + 1
            )
        );

        verifyFact(
            availabilityVerifiersChain,
            availabilityFact,
            "NO_AVAILABILITY_VERIFIERS",
            "NO_AVAILABILITY_PROOF"
        );

        performUpdateState(publicInput, applicationData);
    }

    function getStateTransitionFact(uint256[] calldata publicInput)
        internal
        pure
        returns (bytes32)
    {
        // Use a simple fact tree.
        require(
            publicInput.length >=
                PUB_IN_TRANSACTIONS_DATA_OFFSET +
                    OnchainDataFactTreeEncoder.ONCHAIN_DATA_FACT_ADDITIONAL_WORDS,
            "programOutput does not contain all required fields."
        );
        return
            OnchainDataFactTreeEncoder.encodeFactWithOnchainData(
                publicInput[:publicInput.length -
                    OnchainDataFactTreeEncoder.ONCHAIN_DATA_FACT_ADDITIONAL_WORDS],
                OnchainDataFactTreeEncoder.DataAvailabilityFact({
                    onchainDataHash: publicInput[publicInput.length - 2],
                    onchainDataSize: publicInput[publicInput.length - 1]
                })
            );
    }

    function performUpdateState(uint256[] calldata publicInput, uint256[] calldata applicationData)
        internal
    {
        rootUpdate(
            publicInput[PUB_IN_INITIAL_VALIDIUM_VAULT_ROOT_OFFSET],
            publicInput[PUB_IN_FINAL_VALIDIUM_VAULT_ROOT_OFFSET],
            publicInput[PUB_IN_INITIAL_ROLLUP_VAULT_ROOT_OFFSET],
            publicInput[PUB_IN_FINAL_ROLLUP_VAULT_ROOT_OFFSET],
            publicInput[PUB_IN_INITIAL_ORDER_ROOT_OFFSET],
            publicInput[PUB_IN_FINAL_ORDER_ROOT_OFFSET],
            publicInput[PUB_IN_VALIDIUM_VAULT_TREE_HEIGHT_OFFSET],
            publicInput[PUB_IN_ROLLUP_VAULT_TREE_HEIGHT_OFFSET],
            publicInput[PUB_IN_ORDER_TREE_HEIGHT_OFFSET],
            applicationData[APP_DATA_BATCH_ID_OFFSET]
        );
        performOnchainOperations(publicInput, applicationData);
    }

    function rootUpdate(
        uint256 oldValidiumVaultRoot,
        uint256 newValidiumVaultRoot,
        uint256 oldRollupVaultRoot,
        uint256 newRollupVaultRoot,
        uint256 oldOrderRoot,
        uint256 newOrderRoot,
        uint256 validiumTreeHeightSent,
        uint256 rollupTreeHeightSent,
        uint256 orderTreeHeightSent,
        uint256 batchId
    ) internal virtual {
        // Assert that the old state is correct.
        require(oldValidiumVaultRoot == validiumVaultRoot, "VALIDIUM_VAULT_ROOT_INCORRECT");
        require(oldRollupVaultRoot == rollupVaultRoot, "ROLLUP_VAULT_ROOT_INCORRECT");
        require(oldOrderRoot == orderRoot, "ORDER_ROOT_INCORRECT");

        // Assert that heights are correct.
        require(validiumTreeHeight == validiumTreeHeightSent, "VALIDIUM_TREE_HEIGHT_INCORRECT");
        require(rollupTreeHeight == rollupTreeHeightSent, "ROLLUP_TREE_HEIGHT_INCORRECT");
        require(orderTreeHeight == orderTreeHeightSent, "ORDER_TREE_HEIGHT_INCORRECT");

        // Update state.
        validiumVaultRoot = newValidiumVaultRoot;
        rollupVaultRoot = newRollupVaultRoot;
        orderRoot = newOrderRoot;
        sequenceNumber = sequenceNumber + 1;
        lastBatchId = batchId;

        // Log update.
        emit LogRootUpdate(sequenceNumber, batchId, validiumVaultRoot, rollupVaultRoot, orderRoot);
    }

    function performOnchainOperations(
        uint256[] calldata publicInput,
        uint256[] calldata applicationData
    ) private {
        uint256 nModifications = publicInput[PUB_IN_N_MODIFICATIONS_OFFSET];
        uint256 nCondTransfers = publicInput[PUB_IN_N_CONDITIONAL_TRANSFERS_OFFSET];
        uint256 nOnchainVaultUpdates = publicInput[PUB_IN_N_ONCHAIN_VAULT_UPDATES_OFFSET];
        uint256 nOnchainOrders = publicInput[PUB_IN_N_ONCHAIN_ORDERS_OFFSET];

        // Sanity value that also protects from theoretical overflow in multiplication.
        require(nModifications < 2**64, "Invalid number of modifications.");
        require(nCondTransfers < 2**64, "Invalid number of conditional transfers.");
        require(nOnchainVaultUpdates < 2**64, "Invalid number of onchain vault updates.");
        require(nOnchainOrders < 2**64, "Invalid number of onchain orders.");
        require(
            publicInput.length >=
                PUB_IN_TRANSACTIONS_DATA_OFFSET +
                    PUB_IN_N_WORDS_PER_MODIFICATION *
                    nModifications +
                    PUB_IN_N_WORDS_PER_CONDITIONAL_TRANSFER *
                    nCondTransfers +
                    PUB_IN_N_WORDS_PER_ONCHAIN_VAULT_UPDATE *
                    nOnchainVaultUpdates +
                    PUB_IN_N_MIN_WORDS_PER_ONCHAIN_ORDER *
                    nOnchainOrders +
                    OnchainDataFactTreeEncoder.ONCHAIN_DATA_FACT_ADDITIONAL_WORDS,
            "publicInput size is inconsistent with expected transactions."
        );
        require(
            applicationData.length ==
                APP_DATA_TRANSACTIONS_DATA_OFFSET +
                    APP_DATA_N_WORDS_PER_CONDITIONAL_TRANSFER *
                    nCondTransfers,
            "applicationData size is inconsistent with expected transactions."
        );

        uint256 offsetPubInput = PUB_IN_TRANSACTIONS_DATA_OFFSET;
        uint256 offsetAppData = APP_DATA_TRANSACTIONS_DATA_OFFSET;

        // When reaching this line, offsetPubInput is initialized to the beginning of modifications
        // data in publicInput. Following this line's execution, offsetPubInput is incremented by
        // the number of words consumed by sendModifications.
        offsetPubInput += sendModifications(publicInput[offsetPubInput:], nModifications);

        // When reaching this line, offsetPubInput and offsetAppData are pointing to the beginning
        // of conditional transfers data in publicInput and applicationData.
        // Following the execution of this block, offsetPubInput and offsetAppData are incremented
        // by the number of words consumed by verifyConditionalTransfers.
        {
            uint256 consumedPubInputWords;
            uint256 consumedAppDataWords;
            (consumedPubInputWords, consumedAppDataWords) = verifyConditionalTransfers(
                publicInput[offsetPubInput:],
                applicationData[offsetAppData:],
                nCondTransfers
            );

            offsetPubInput += consumedPubInputWords;
            offsetAppData += consumedAppDataWords;
        }

        // offsetPubInput is incremented by the number of words consumed by updateOnchainVaults.
        // NOLINTNEXTLINE: reentrancy-benign.
        offsetPubInput += updateOnchainVaults(publicInput[offsetPubInput:], nOnchainVaultUpdates);

        // offsetPubInput is incremented by the number of words consumed by verifyOnchainOrders.
        offsetPubInput += verifyOnchainOrders(publicInput[offsetPubInput:], nOnchainOrders);

        // The Onchain Data info appears at the end of publicInput.
        offsetPubInput += OnchainDataFactTreeEncoder.ONCHAIN_DATA_FACT_ADDITIONAL_WORDS;

        require(offsetPubInput == publicInput.length, "Incorrect Size");
    }

    /*
      Deposits and withdrawals. Moves funds off and on chain.
        slidingPublicInput - a pointer to the beginning of modifications data in publicInput.
        nModifications - the number of modifications.
      Returns the number of publicInput words consumed by this function.
    */
    function sendModifications(uint256[] calldata slidingPublicInput, uint256 nModifications)
        private
        returns (uint256 consumedPubInputItems)
    {
        uint256 offsetPubInput = 0;

        for (uint256 i = 0; i < nModifications; i++) {
            uint256 ownerKey = slidingPublicInput[offsetPubInput];
            uint256 assetId = slidingPublicInput[offsetPubInput + 1];

            require(ownerKey < K_MODULUS, "Stark key >= PRIME");
            require(assetId < K_MODULUS, "Asset id >= PRIME");

            uint256 actionParams = slidingPublicInput[offsetPubInput + 2];
            require((actionParams >> 129) == 0, "Unsupported modification action field.");

            // Extract and unbias the balanceDiff.
            int256 balanceDiff = int256((actionParams & ((1 << 64) - 1)) - (1 << 63));
            uint256 vaultId = (actionParams >> 64) & ((1 << 64) - 1);

            if (balanceDiff > 0) {
                // This is a deposit.
                acceptDeposit(ownerKey, vaultId, assetId, uint256(balanceDiff));
            } else if (balanceDiff < 0) {
                // This is a withdrawal.
                acceptWithdrawal(ownerKey, assetId, uint256(-balanceDiff));
            }

            if ((actionParams & (1 << 128)) != 0) {
                clearFullWithdrawalRequest(ownerKey, vaultId);
            }

            offsetPubInput += PUB_IN_N_WORDS_PER_MODIFICATION;
        }
        return offsetPubInput;
    }

    /*
      Verifies that each conditional transfer's condition was met.
        slidingPublicInput - a pointer to the beginning of condTransfers data in publicInput.
        slidingAppData - a pointer to the beginning of condTransfers data in applicationData.
        nCondTransfers - the number of conditional transfers.
      Returns the number of publicInput and applicationData words consumed by this function.
    */
    function verifyConditionalTransfers(
        uint256[] calldata slidingPublicInput,
        uint256[] calldata slidingAppData,
        uint256 nCondTransfers
    ) private view returns (uint256 consumedPubInputItems, uint256 consumedAppDataItems) {
        uint256 offsetPubInput = 0;
        uint256 offsetAppData = 0;

        for (uint256 i = 0; i < nCondTransfers; i++) {
            address factRegistryAddress = address(slidingAppData[offsetAppData]);
            bytes32 condTransferFact = bytes32(slidingAppData[offsetAppData + 1]);
            uint256 condition = slidingPublicInput[offsetPubInput];

            // The condition is the 250 LS bits of keccak256 of the fact registry & fact.
            require(
                condition ==
                    uint256(keccak256(abi.encodePacked(factRegistryAddress, condTransferFact))) &
                        MASK_250,
                "Condition mismatch."
            );
            // NOLINTNEXTLINE: low-level-calls-loop.
            (bool success, bytes memory returndata) = factRegistryAddress.staticcall(
                abi.encodeWithSignature("isValid(bytes32)", condTransferFact)
            );
            require(success && returndata.length == 32, "BAD_FACT_REGISTRY_CONTRACT");
            require(
                abi.decode(returndata, (bool)),
                "Condition for the conditional transfer was not met."
            );

            offsetPubInput += PUB_IN_N_WORDS_PER_CONDITIONAL_TRANSFER;
            offsetAppData += APP_DATA_N_WORDS_PER_CONDITIONAL_TRANSFER;
        }
        return (offsetPubInput, offsetAppData);
    }

    /*
      Moves funds into and out of onchain vaults.
        slidingPublicInput - a pointer to the beginning of onchain vaults update data in publicInput.
        nOnchainVaultUpdates - the number of onchain vaults updates.
      Returns the number of publicInput words consumed by this function.
    */
    function updateOnchainVaults(
        uint256[] calldata slidingPublicInput,
        uint256 nOnchainVaultUpdates
    ) private returns (uint256 consumedPubInputItems) {
        uint256 offsetPubInput = 0;

        for (uint256 i = 0; i < nOnchainVaultUpdates; i++) {
            address ethAddress = address(slidingPublicInput[offsetPubInput]);
            uint256 assetId = slidingPublicInput[offsetPubInput + 1];

            require(assetId < K_MODULUS, "assetId >= PRIME");

            uint256 additionalParams = slidingPublicInput[offsetPubInput + 2];
            require((additionalParams >> 160) == 0, "Unsupported vault update field.");

            // Extract and unbias the balanceDiff.
            int256 balanceDiff = int256((additionalParams & ((1 << 64) - 1)) - (1 << 63));

            int256 minBalance = int256((additionalParams >> 64) & ((1 << 64) - 1));
            uint256 vaultId = (additionalParams >> 128) & ((1 << 31) - 1);

            int256 balanceBefore = int256(vaultsBalances[ethAddress][assetId][vaultId]);
            int256 newBalance = balanceBefore + balanceDiff;

            if (balanceDiff > 0) {
                require(newBalance > balanceBefore, "VAULT_OVERFLOW");
            } else {
                require(balanceBefore >= balanceDiff, "INSUFFICIENT_VAULT_BALANCE");
            }

            if (strictVaultBalancePolicy) {
                require(minBalance >= 0, "ILLEGAL_BALANCE_REQUIREMENT");
                require(balanceBefore >= minBalance, "UNMET_BALANCE_REQUIREMENT");
            }

            require(newBalance >= 0, "NEGATIVE_BALANCE");
            vaultsBalances[ethAddress][assetId][vaultId] = uint256(newBalance);
            // NOLINTNEXTLINE: reentrancy-events.
            emit LogVaultBalanceChangeApplied(ethAddress, assetId, vaultId, balanceDiff);

            offsetPubInput += PUB_IN_N_WORDS_PER_ONCHAIN_VAULT_UPDATE;
        }
        return offsetPubInput;
    }

    /*
      Verifies that each order was registered by its sender.
        slidingPublicInput - a pointer to the beginning of onchain orders data in publicInput.
        nOnchainOrders - the number of onchain orders.
      Returns the number of publicInput words consumed by this function.
    */
    function verifyOnchainOrders(uint256[] calldata slidingPublicInput, uint256 nOnchainOrders)
        private
        view
        returns (uint256 consumedPubInputItems)
    {
        MessageRegistry orderRegistry = MessageRegistry(orderRegistryAddress);
        uint256 offsetPubInput = 0;

        for (uint256 i = 0; i < nOnchainOrders; i++) {
            // Make sure we remain within slidingPublicInput's bounds.
            require(offsetPubInput + 2 <= slidingPublicInput.length, "Input out of bounds.");
            // First word is the order sender.
            address orderSender = address(slidingPublicInput[offsetPubInput]);
            // Second word is the order blob size (number of blob words) that follow.
            uint256 blobSize = uint256(slidingPublicInput[offsetPubInput + 1]);
            require(offsetPubInput + blobSize + 2 >= offsetPubInput, "Blob size overflow.");

            offsetPubInput += 2;
            require(offsetPubInput + blobSize <= slidingPublicInput.length, "Input out of bounds.");
            // Calculate the hash of the order blob.
            bytes32 orderHash = keccak256(
                abi.encodePacked(slidingPublicInput[offsetPubInput:offsetPubInput + blobSize])
            );

            // Verify this order has been registered.
            require(
                orderRegistry.isMessageRegistered(orderSender, address(this), orderHash),
                "Order not registered."
            );

            offsetPubInput += blobSize;
        }
        return offsetPubInput;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/Freezable.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;




/*
  Implements MFreezable.
*/
abstract contract Freezable is MainStorage, LibConstants, MGovernance, MFreezable {
    event LogFrozen();
    event LogUnFrozen();

    function isFrozen() public view override returns (bool) {
        return stateFrozen;
    }

    function validateFreezeRequest(uint256 requestTime) internal override {
        require(requestTime != 0, "FORCED_ACTION_UNREQUESTED");
        // Verify timer on escape request.
        uint256 freezeTime = requestTime + FREEZE_GRACE_PERIOD;

        // Prevent wraparound.
        assert(freezeTime >= FREEZE_GRACE_PERIOD);
        require(block.timestamp >= freezeTime, "FORCED_ACTION_PENDING"); // NOLINT: timestamp.

        // Forced action requests placed before freeze, are no longer valid after the un-freeze.
        require(freezeTime > unFreezeTime, "REFREEZE_ATTEMPT");
    }

    function freeze() internal override notFrozen {
        unFreezeTime = block.timestamp + UNFREEZE_DELAY;

        // Update state.
        stateFrozen = true;

        // Log event.
        emit LogFrozen();
    }

    function unFreeze() external onlyFrozen onlyGovernance {
        require(block.timestamp >= unFreezeTime, "UNFREEZE_NOT_ALLOWED_YET");

        // Update state.
        stateFrozen = false;

        // Increment roots to invalidate them, w/o losing information.
        validiumVaultRoot += 1;
        rollupVaultRoot += 1;
        orderRoot += 1;

        // Log event.
        emit LogUnFrozen();
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/Governance.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Implements Generic Governance, applicable for both proxy and main contract, and possibly others.
  Notes:
   The use of the same function names by both the Proxy and a delegated implementation
   is not possible since calling the implementation functions is done via the default function
   of the Proxy. For this reason, for example, the implementation of MainContract (MainGovernance)
   exposes mainIsGovernor, which calls the internal _isGovernor method.
*/
abstract contract Governance is MGovernance {
    event LogNominatedGovernor(address nominatedGovernor);
    event LogNewGovernorAccepted(address acceptedGovernor);
    event LogRemovedGovernor(address removedGovernor);
    event LogNominationCancelled();

    function getGovernanceInfo() internal view virtual returns (GovernanceInfoStruct storage);

    /*
      Current code intentionally prevents governance re-initialization.
      This may be a problem in an upgrade situation, in a case that the upgrade-to implementation
      performs an initialization (for real) and within that calls initGovernance().

      Possible workarounds:
      1. Clearing the governance info altogether by changing the MAIN_GOVERNANCE_INFO_TAG.
         This will remove existing main governance information.
      2. Modify the require part in this function, so that it will exit quietly
         when trying to re-initialize (uncomment the lines below).
    */
    function initGovernance() internal {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(!gub.initialized, "ALREADY_INITIALIZED");
        gub.initialized = true; // to ensure addGovernor() won't fail.
        // Add the initial governer.
        addGovernor(msg.sender);
    }

    function _isGovernor(address testGovernor) internal view override returns (bool) {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        return gub.effectiveGovernors[testGovernor];
    }

    /*
      Cancels the nomination of a governor candidate.
    */
    function _cancelNomination() internal onlyGovernance {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        gub.candidateGovernor = address(0x0);
        emit LogNominationCancelled();
    }

    function _nominateNewGovernor(address newGovernor) internal onlyGovernance {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(!_isGovernor(newGovernor), "ALREADY_GOVERNOR");
        gub.candidateGovernor = newGovernor;
        emit LogNominatedGovernor(newGovernor);
    }

    /*
      The addGovernor is called in two cases:
      1. by _acceptGovernance when a new governor accepts its role.
      2. by initGovernance to add the initial governor.
      The difference is that the init path skips the nominate step
      that would fail because of the onlyGovernance modifier.
    */
    function addGovernor(address newGovernor) private {
        require(!_isGovernor(newGovernor), "ALREADY_GOVERNOR");
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        gub.effectiveGovernors[newGovernor] = true;
    }

    function _acceptGovernance() internal {
        // The new governor was proposed as a candidate by the current governor.
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(msg.sender == gub.candidateGovernor, "ONLY_CANDIDATE_GOVERNOR");

        // Update state.
        addGovernor(gub.candidateGovernor);
        gub.candidateGovernor = address(0x0);

        // Send a notification about the change of governor.
        emit LogNewGovernorAccepted(msg.sender);
    }

    /*
      Remove a governor from office.
    */
    function _removeGovernor(address governorForRemoval) internal onlyGovernance {
        require(msg.sender != governorForRemoval, "GOVERNOR_SELF_REMOVE");
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(_isGovernor(governorForRemoval), "NOT_GOVERNOR");
        gub.effectiveGovernors[governorForRemoval] = false;
        emit LogRemovedGovernor(governorForRemoval);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/MainGovernance.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


/**
  The StarkEx contract is governed by one or more Governors of which the initial one is the
  deployer of the contract.

  A governor has the sole authority to perform the following operations:

  1. Nominate additional governors (:sol:func:`mainNominateNewGovernor`)
  2. Remove other governors (:sol:func:`mainRemoveGovernor`)
  3. Add new :sol:mod:`Verifiers` and :sol:mod:`AvailabilityVerifiers`
  4. Remove :sol:mod:`Verifiers` and :sol:mod:`AvailabilityVerifiers` after a timelock allows it
  5. Nominate Operators (see :sol:mod:`Operator`) and Token Administrators (see :sol:mod:`TokenRegister`)

  Adding governors is performed in a two step procedure:

  1. First, an existing governor nominates a new governor (:sol:func:`mainNominateNewGovernor`)
  2. Then, the new governor must accept governance to become a governor (:sol:func:`mainAcceptGovernance`)

  This two step procedure ensures that a governor public key cannot be nominated unless there is an
  entity that has the corresponding private key. This is intended to prevent errors in the addition
  process.

  The governor private key should typically be held in a secure cold wallet.
*/
/*
  Implements Governance for the StarkDex main contract.
  The wrapper methods (e.g. mainIsGovernor wrapping _isGovernor) are needed to give
  the method unique names.
  Both Proxy and StarkExchange inherit from Governance. Thus, the logical contract method names
  must have unique names in order for the proxy to successfully delegate to them.
*/
contract MainGovernance is GovernanceStorage, Governance {
    // The tag is the sting key that is used in the Governance storage mapping.
    string public constant MAIN_GOVERNANCE_INFO_TAG = "StarkEx.Main.2019.GovernorsInformation";

    /*
      Returns the GovernanceInfoStruct associated with the governance tag.
    */
    function getGovernanceInfo() internal view override returns (GovernanceInfoStruct storage) {
        return governanceInfo[MAIN_GOVERNANCE_INFO_TAG];
    }

    function mainIsGovernor(address testGovernor) external view returns (bool) {
        return _isGovernor(testGovernor);
    }

    function mainNominateNewGovernor(address newGovernor) external {
        _nominateNewGovernor(newGovernor);
    }

    function mainRemoveGovernor(address governorForRemoval) external {
        _removeGovernor(governorForRemoval);
    }

    function mainAcceptGovernance() external {
        _acceptGovernance();
    }

    function mainCancelNomination() external {
        _cancelNomination();
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/Operator.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


/**
  The Operator of the contract is the entity entitled to submit state update requests
  by calling :sol:func:`updateState`.

  An Operator may be instantly appointed or removed by the contract Governor
  (see :sol:mod:`Governance`). Typically, the Operator is the hot wallet of the service
  submitting proofs for state updates.
*/
abstract contract Operator is MGovernance, MOperator {
    function registerOperator(address newOperator) external override onlyGovernance {
        getOperators()[newOperator] = true;
        emit LogOperatorAdded(newOperator);
    }

    function unregisterOperator(address removedOperator) external override onlyGovernance {
        getOperators()[removedOperator] = false;
        emit LogOperatorRemoved(removedOperator);
    }

    function isOperator(address testedOperator) public view override returns (bool) {
        return getOperators()[testedOperator];
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/StarkExOperator.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


/**
  Operator implementation for StarkEx (StarkExchange & StarkPerpetual).
*/
abstract contract StarkExOperator is MainStorage, Operator {
    function initialize() internal {
        getOperators()[msg.sender] = true;
        emit LogOperatorAdded(msg.sender);
    }

    function getOperators() internal view override returns (mapping(address => bool) storage) {
        return operators;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MTokenQuantization.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MTokenQuantization {
    function fromQuantized(uint256 presumedAssetType, uint256 quantizedAmount)
        internal
        view
        virtual
        returns (uint256 amount);

    // NOLINTNEXTLINE: external-function.
    function getQuantum(uint256 presumedAssetType) public view virtual returns (uint256 quantum);

    function toQuantized(uint256 presumedAssetType, uint256 amount)
        internal
        view
        virtual
        returns (uint256 quantizedAmount);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interactions/AcceptModifications.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;




/*
  Interface containing actions a verifier can invoke on the state.
  The contract containing the state should implement these and verify correctness.
*/
abstract contract AcceptModifications is
    MainStorage,
    LibConstants,
    MAcceptModifications,
    MTokenQuantization
{
    event LogWithdrawalAllowed(
        uint256 ownerKey,
        uint256 assetType,
        uint256 nonQuantizedAmount,
        uint256 quantizedAmount
    );

    event LogNftWithdrawalAllowed(uint256 ownerKey, uint256 assetId);

    event LogAssetWithdrawalAllowed(uint256 ownerKey, uint256 assetId, uint256 quantizedAmount);

    event LogMintableWithdrawalAllowed(uint256 ownerKey, uint256 assetId, uint256 quantizedAmount);

    /*
      Transfers funds from the on-chain deposit area to the off-chain area.
      Implemented in the Deposits contracts.
    */
    function acceptDeposit(
        uint256 ownerKey,
        uint256 vaultId,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal virtual override {
        // Fetch deposit.
        require(
            pendingDeposits[ownerKey][assetId][vaultId] >= quantizedAmount,
            "DEPOSIT_INSUFFICIENT"
        );

        // Subtract accepted quantized amount.
        pendingDeposits[ownerKey][assetId][vaultId] -= quantizedAmount;
    }

    /*
      Transfers funds from the off-chain area to the on-chain withdrawal area.
    */
    function allowWithdrawal(
        uint256 ownerKey,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal override {
        // Fetch withdrawal.
        uint256 withdrawal = pendingWithdrawals[ownerKey][assetId];

        // Add accepted quantized amount.
        withdrawal += quantizedAmount;
        require(withdrawal >= quantizedAmount, "WITHDRAWAL_OVERFLOW");

        // Store withdrawal.
        pendingWithdrawals[ownerKey][assetId] = withdrawal;

        // Log event.
        uint256 presumedAssetType = assetId;
        if (registeredAssetType[presumedAssetType]) {
            emit LogWithdrawalAllowed(
                ownerKey,
                presumedAssetType,
                fromQuantized(presumedAssetType, quantizedAmount),
                quantizedAmount
            );
        } else if (assetId == ((assetId & MASK_240) | MINTABLE_ASSET_ID_FLAG)) {
            emit LogMintableWithdrawalAllowed(ownerKey, assetId, quantizedAmount);
        } else {
            // Default case is Non-Mintable ERC721 or ERC1155 asset id.
            // In ERC721 and ERC1155 cases, assetId is not the assetType.
            require(assetId == assetId & MASK_250, "INVALID_ASSET_ID");
            // If withdrawal amount is 1, the asset could be either NFT or SFT. In that case, both
            // NFT and general events will be emitted so that the listened for event is captured.
            // When withdrawal is greater than 1, it must be SFT and only one event will be emitted.
            if (withdrawal <= 1) {
                emit LogNftWithdrawalAllowed(ownerKey, assetId);
            }
            emit LogAssetWithdrawalAllowed(ownerKey, assetId, quantizedAmount);
        }
    }

    // Verifier authorizes withdrawal.
    function acceptWithdrawal(
        uint256 ownerKey,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal virtual override {
        allowWithdrawal(ownerKey, assetId, quantizedAmount);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interactions/StateRoot.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


contract StateRoot is MainStorage, MStateRoot {
    function initialize(
        uint256 initialSequenceNumber,
        uint256 initialValidiumVaultRoot,
        uint256 initialRollupVaultRoot,
        uint256 initialOrderRoot,
        uint256 initialValidiumTreeHeight,
        uint256 initialRollupTreeHeight,
        uint256 initialOrderTreeHeight
    ) internal {
        sequenceNumber = initialSequenceNumber;
        validiumVaultRoot = initialValidiumVaultRoot;
        rollupVaultRoot = initialRollupVaultRoot;
        orderRoot = initialOrderRoot;
        validiumTreeHeight = initialValidiumTreeHeight;
        rollupTreeHeight = initialRollupTreeHeight;
        orderTreeHeight = initialOrderTreeHeight;
    }

    function getValidiumVaultRoot() public view override returns (uint256) {
        return validiumVaultRoot;
    }

    function getValidiumTreeHeight() public view override returns (uint256) {
        return validiumTreeHeight;
    }

    function getRollupVaultRoot() public view override returns (uint256) {
        return rollupVaultRoot;
    }

    function getRollupTreeHeight() public view override returns (uint256) {
        return rollupTreeHeight;
    }

    function getOrderRoot() external view returns (uint256) {
        return orderRoot;
    }

    function getOrderTreeHeight() external view returns (uint256) {
        return orderTreeHeight;
    }

    function getSequenceNumber() external view returns (uint256) {
        return sequenceNumber;
    }

    function getLastBatchId() external view returns (uint256) {
        return lastBatchId;
    }

    function getGlobalConfigCode() external view returns (uint256) {
        return globalConfigCode;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interactions/TokenQuantization.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


contract TokenQuantization is MainStorage, MTokenQuantization {
    function fromQuantized(uint256 presumedAssetType, uint256 quantizedAmount)
        internal
        view
        override
        returns (uint256 amount)
    {
        uint256 quantum = getQuantum(presumedAssetType);
        amount = quantizedAmount * quantum;
        require(amount / quantum == quantizedAmount, "DEQUANTIZATION_OVERFLOW");
    }

    function getQuantum(uint256 presumedAssetType) public view override returns (uint256 quantum) {
        if (!registeredAssetType[presumedAssetType]) {
            // Default quantization, for NFTs etc.
            quantum = 1;
        } else {
            // Retrieve registration.
            quantum = assetTypeToQuantum[presumedAssetType];
        }
    }

    function toQuantized(uint256 presumedAssetType, uint256 amount)
        internal
        view
        override
        returns (uint256 quantizedAmount)
    {
        uint256 quantum = getQuantum(presumedAssetType);
        require(amount % quantum == 0, "INVALID_AMOUNT");
        quantizedAmount = amount / quantum;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/SubContractor.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

interface SubContractor is Identity {
    function initialize(bytes calldata data) external;

    function initializerSize() external view returns (uint256);

    /*
      Returns an array with selectors for validation.
      These selectors are the critical ones for maintaining self custody and anti censorship.
      During the upgrade process, as part of the sub-contract validation, the MainDispatcher
      validates that the selectos are mapped to the correct sub-contract.
    */
    function validatedSelectors() external pure returns (bytes4[] memory);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/toplevel_subcontracts/StarkExState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;










contract StarkExState is
    MainGovernance,
    SubContractor,
    StarkExOperator,
    Freezable,
    AcceptModifications,
    TokenQuantization,
    StarkExForcedActionState,
    StateRoot,
    Escapes,
    UpdateState
{
    // InitializationArgStruct contains 2 * address + 8 * uint256 + 1 * bool = 352 bytes.
    uint256 constant INITIALIZER_SIZE = 11 * 32;

    struct InitializationArgStruct {
        uint256 globalConfigCode;
        address escapeVerifierAddress;
        uint256 sequenceNumber;
        uint256 validiumVaultRoot;
        uint256 rollupVaultRoot;
        uint256 orderRoot;
        uint256 validiumTreeHeight;
        uint256 rollupTreeHeight;
        uint256 orderTreeHeight;
        bool strictVaultBalancePolicy;
        address orderRegistryAddress;
    }

    /*
      Initialization flow:
      1. Extract initialization parameters from data.
      2. Call internalInitializer with those parameters.
    */
    function initialize(bytes calldata data) external virtual override {
        // This initializer sets roots etc. It must not be applied twice.
        // I.e. it can run only when the state is still empty.
        string memory ALREADY_INITIALIZED_MSG = "STATE_ALREADY_INITIALIZED";
        require(validiumVaultRoot == 0, ALREADY_INITIALIZED_MSG);
        require(validiumTreeHeight == 0, ALREADY_INITIALIZED_MSG);
        require(rollupVaultRoot == 0, ALREADY_INITIALIZED_MSG);
        require(rollupTreeHeight == 0, ALREADY_INITIALIZED_MSG);
        require(orderRoot == 0, ALREADY_INITIALIZED_MSG);
        require(orderTreeHeight == 0, ALREADY_INITIALIZED_MSG);

        require(data.length == INITIALIZER_SIZE, "INCORRECT_INIT_DATA_SIZE_352");

        // Copies initializer values into initValues.
        InitializationArgStruct memory initValues;
        bytes memory _data = data;
        assembly {
            initValues := add(32, _data)
        }
        require(initValues.globalConfigCode < K_MODULUS, "GLOBAL_CONFIG_CODE >= PRIME");

        initGovernance();
        StarkExOperator.initialize();
        StateRoot.initialize(
            initValues.sequenceNumber,
            initValues.validiumVaultRoot,
            initValues.rollupVaultRoot,
            initValues.orderRoot,
            initValues.validiumTreeHeight,
            initValues.rollupTreeHeight,
            initValues.orderTreeHeight
        );
        Escapes.initialize(initValues.escapeVerifierAddress);
        globalConfigCode = initValues.globalConfigCode;
        strictVaultBalancePolicy = initValues.strictVaultBalancePolicy;
        orderRegistryAddress = initValues.orderRegistryAddress;
    }

    /*
      The call to initializerSize is done from MainDispatcherBase using delegatecall,
      thus the existing state is already accessible.
    */
    function initializerSize() external view virtual override returns (uint256) {
        return INITIALIZER_SIZE;
    }

    function validatedSelectors() external pure override returns (bytes4[] memory selectors) {
        uint256 len_ = 1;
        uint256 index_ = 0;

        selectors = new bytes4[](len_);
        selectors[index_++] = Escapes.escape.selector;
        require(index_ == len_, "INCORRECT_SELECTORS_ARRAY_LENGTH");
    }

    function identify() external pure override returns (string memory) {
        return "StarkWare_StarkExState_2022_4";
    }
}
