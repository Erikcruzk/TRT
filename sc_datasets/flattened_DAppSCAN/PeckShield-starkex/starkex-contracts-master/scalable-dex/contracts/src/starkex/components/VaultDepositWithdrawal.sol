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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/interfaces/MVaultLocks.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Onchain vaults' lock functionality.
*/
abstract contract MVaultLocks {
    function applyDefaultLock(uint256 assetId, uint256 vaultId) internal virtual;

    function isVaultLocked(
        address ethKey,
        uint256 assetId,
        uint256 vaultId
    ) public view virtual returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MTokenTransfers.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MTokenTransfers {
    function transferIn(uint256 assetType, uint256 quantizedAmount) internal virtual;

    function transferInWithTokenId(
        uint256 assetType,
        uint256 tokenId,
        uint256 quantizedAmount
    ) internal virtual;

    function transferOut(
        address payable recipient,
        uint256 assetType,
        uint256 quantizedAmount
    ) internal virtual;

    function transferOutWithTokenId(
        address recipient,
        uint256 assetType,
        uint256 tokenId,
        uint256 quantizedAmount
    ) internal virtual;

    function transferOutMint(
        uint256 assetType,
        uint256 quantizedAmount,
        address recipient,
        bytes calldata mintingBlob
    ) internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MTokenAssetData.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MTokenAssetData {
    // NOLINTNEXTLINE: external-function.
    function getAssetInfo(uint256 assetType) public view virtual returns (bytes memory);

    function isEther(uint256 assetType) internal view virtual returns (bool);

    function isERC20(uint256 assetType) internal view virtual returns (bool);

    function isERC721(uint256 assetType) internal view virtual returns (bool);

    function isERC1155(uint256 assetType) internal view virtual returns (bool);

    function isFungibleAssetType(uint256 assetType) internal view virtual returns (bool);

    function isMintableAssetType(uint256 assetType) internal view virtual returns (bool);

    function isAssetTypeWithTokenId(uint256 assetType) internal view virtual returns (bool);

    function extractContractAddress(uint256 assetType) internal view virtual returns (address);

    function verifyAssetInfo(bytes memory assetInfo) internal view virtual;

    function isNonFungibleAssetInfo(bytes memory assetInfo) internal pure virtual returns (bool);

    function calculateAssetIdWithTokenId(uint256 assetType, uint256 tokenId)
        public
        view
        virtual
        returns (uint256);

    function calculateMintableAssetId(uint256 assetType, bytes memory mintingBlob)
        public
        pure
        virtual
        returns (uint256);
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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/starkex/components/VaultDepositWithdrawal.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;





/*
  Onchain vaults deposit and withdrawal functionalities.
*/
abstract contract VaultDepositWithdrawal is
    StarkExStorage,
    MVaultLocks,
    MTokenQuantization,
    MTokenAssetData,
    MTokenTransfers
{
    event LogDepositToVault(
        address ethKey,
        uint256 assetType,
        uint256 assetId,
        uint256 vaultId,
        uint256 nonQuantizedAmount,
        uint256 quantizedAmount
    );

    event LogWithdrawalFromVault(
        address ethKey,
        uint256 assetType,
        uint256 assetId,
        uint256 vaultId,
        uint256 nonQuantizedAmount,
        uint256 quantizedAmount
    );

    function getQuantizedVaultBalance(
        address ethKey,
        uint256 assetId,
        uint256 vaultId
    ) public view returns (uint256) {
        return vaultsBalances[ethKey][assetId][vaultId];
    }

    function getVaultBalance(
        address ethKey,
        uint256 assetId,
        uint256 vaultId
    ) external view returns (uint256) {
        return fromQuantized(assetId, getQuantizedVaultBalance(ethKey, assetId, vaultId));
    }

    function getQuantizedErc1155VaultBalance(
        address ethKey,
        uint256 assetType,
        uint256 tokenId,
        uint256 vaultId
    ) external view returns (uint256) {
        uint256 assetId = calculateAssetIdWithTokenId(assetType, tokenId);
        return vaultsBalances[ethKey][assetId][vaultId];
    }

    function updateVaultForDeposit(
        uint256 assetId,
        uint256 vaultId,
        uint256 quantizedAmount
    ) private {
        // A default withdrawal lock is applied when deposits are made.
        applyDefaultLock(assetId, vaultId);
        // Update the balance.
        vaultsBalances[msg.sender][assetId][vaultId] += quantizedAmount;
        require(vaultsBalances[msg.sender][assetId][vaultId] >= quantizedAmount, "VAULT_OVERFLOW");
    }

    // NOLINTNEXTLINE: locked-ether.
    function depositEthToVault(uint256 assetType, uint256 vaultId) external payable {
        require(isEther(assetType), "INVALID_ASSET_TYPE");
        // Update the vault balance and apply default lock.
        uint256 quantizedAmount = toQuantized(assetType, msg.value);
        uint256 assetId = assetType;
        updateVaultForDeposit(assetId, vaultId, quantizedAmount);
        // Transfer the tokens to the contract.
        transferIn(assetType, quantizedAmount);
        // Log event.
        emit LogDepositToVault(
            msg.sender,
            assetType,
            assetId,
            vaultId,
            fromQuantized(assetId, quantizedAmount),
            quantizedAmount
        );
    }

    function depositERC20ToVault(
        uint256 assetType,
        uint256 vaultId,
        uint256 quantizedAmount
    ) external {
        require(isERC20(assetType), "NOT_ERC20_ASSET_TYPE");
        // Update the vault balance and apply default lock.
        uint256 assetId = assetType;
        updateVaultForDeposit(assetId, vaultId, quantizedAmount);
        // Transfer the tokens to the contract.
        transferIn(assetType, quantizedAmount);
        // Log event.
        emit LogDepositToVault(
            msg.sender,
            assetType,
            assetId,
            vaultId,
            fromQuantized(assetId, quantizedAmount),
            quantizedAmount
        );
    }

    function depositERC1155ToVault(
        uint256 assetType,
        uint256 tokenId,
        uint256 vaultId,
        uint256 quantizedAmount
    ) external {
        require(isERC1155(assetType), "NOT_ERC1155_TOKEN");
        // Update the vault balance and apply default lock.
        uint256 assetId = calculateAssetIdWithTokenId(assetType, tokenId);
        updateVaultForDeposit(assetId, vaultId, quantizedAmount);
        // Transfer the tokens to the contract.
        transferInWithTokenId(assetType, tokenId, quantizedAmount);
        // Log event.
        emit LogDepositToVault(
            msg.sender,
            assetType,
            assetId,
            vaultId,
            fromQuantized(assetId, quantizedAmount),
            quantizedAmount
        );
    }

    function updateVaultForWithdrawal(
        uint256 assetId,
        uint256 vaultId,
        uint256 quantizedAmount
    ) private {
        require(quantizedAmount > 0, "ZERO_WITHDRAWAL");
        // Make sure the vault is not locked for withdrawals.
        require(!isVaultLocked(msg.sender, assetId, vaultId), "VAULT_IS_LOCKED");
        // Make sure the vault contains sufficient funds.
        uint256 vaultBalance = vaultsBalances[msg.sender][assetId][vaultId];
        require(vaultBalance >= quantizedAmount, "INSUFFICIENT_BALANCE");
        // Update the balance.
        vaultsBalances[msg.sender][assetId][vaultId] = vaultBalance - quantizedAmount;
    }

    function withdrawFromVault(
        uint256 assetType,
        uint256 vaultId,
        uint256 quantizedAmount
    ) external {
        require(isFungibleAssetType(assetType), "NON_FUNGIBLE_ASSET_TYPE");
        require(!isMintableAssetType(assetType), "MINTABLE_ASSET_TYPE");
        // Update the vault balance and check withdrawal lock.
        uint256 assetId = assetType;
        updateVaultForWithdrawal(assetId, vaultId, quantizedAmount);
        // Transfer funds.
        transferOut(msg.sender, assetType, quantizedAmount);
        // Log event.
        emit LogWithdrawalFromVault(
            msg.sender,
            assetType,
            assetId,
            vaultId,
            fromQuantized(assetId, quantizedAmount),
            quantizedAmount
        );
    }

    function withdrawErc1155FromVault(
        uint256 assetType,
        uint256 tokenId,
        uint256 vaultId,
        uint256 quantizedAmount
    ) external {
        require(isERC1155(assetType), "NOT_ERC1155_TOKEN");
        // Update the vault balance and check withdrawal lock.
        uint256 assetId = calculateAssetIdWithTokenId(assetType, tokenId);
        updateVaultForWithdrawal(assetId, vaultId, quantizedAmount);
        // Transfer funds.
        transferOutWithTokenId(msg.sender, assetType, tokenId, quantizedAmount);
        // Log event.
        emit LogWithdrawalFromVault(
            msg.sender,
            assetType,
            assetId,
            vaultId,
            fromQuantized(assetId, quantizedAmount),
            quantizedAmount
        );
    }
}
