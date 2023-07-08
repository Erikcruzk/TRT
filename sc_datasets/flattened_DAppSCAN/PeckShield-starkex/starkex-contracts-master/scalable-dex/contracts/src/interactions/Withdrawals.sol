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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MKeyGetters.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MKeyGetters {
    // NOLINTNEXTLINE: external-function.
    function getEthKey(uint256 ownerKey) public view virtual returns (address);

    function strictGetEthKey(uint256 ownerKey) internal view virtual returns (address);

    function isMsgSenderKeyOwner(uint256 ownerKey) internal view virtual returns (bool);

    /*
      Allows calling the function only if ownerKey is registered to msg.sender.
    */
    modifier onlyKeyOwner(uint256 ownerKey) {
        // Require the calling user to own the stark key.
        require(msg.sender == strictGetEthKey(ownerKey), "MISMATCHING_STARK_ETH_KEYS");
        _;
    }
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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interactions/Withdrawals.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;







/**
  For a user to perform a withdrawal operation from the Stark Exchange during normal operation
  two calls are required:

  1. A call to an offchain exchange API, requesting a withdrawal from a user account (vault).
  2. A call to the on-chain :sol:func:`withdraw` function to perform the actual withdrawal of funds transferring them to the users Eth or ERC20 account (depending on the token type).

  For simplicity, hereafter it is assumed that all tokens are ERC20 tokens but the text below
  applies to Eth in the same manner.

  In the first call mentioned above, anyone can call the API to request the withdrawal of an
  amount from a given vault. Following the request, the exchange may include the withdrawal in a
  STARK proof. The submission of a proof then results in the addition of the amount(s) withdrawn to
  an on-chain pending withdrawals account under the stark key of the vault owner and the appropriate
  asset ID. At the same time, this also implies that this amount is deducted from the off-chain
  vault.

  Once the amount to be withdrawn has been transfered to the on-chain pending withdrawals account,
  the user may perform the second call mentioned above to complete the transfer of funds from the
  Stark Exchange contract to the appropriate ERC20 account. Only a user holding the Eth key
  corresponding to the Stark Key of a pending withdrawals account may perform this operation.

  It is possible that for multiple withdrawal calls to the API, a single withdrawal call to the
  contract may retrieve all funds, as long as they are all for the same asset ID.

  The result of the operation, assuming all requirements are met, is that an amount of ERC20 tokens
  in the pending withdrawal account times the quantization factor is transferred to the ERC20
  account of the user.

  A withdrawal request cannot be cancelled. Once funds reach the pending withdrawals account
  on-chain, they cannot be moved back into an off-chain vault before completion of the withdrawal
  to the ERC20 account of the user.

  In the event that the exchange reaches a frozen state the user may perform a withdrawal operation
  via an alternative flow, known as the "Escape" flow. In this flow, the API call above is replaced
  with an :sol:func:`escape` call to the on-chain contract (see :sol:mod:`Escapes`) proving the
  ownership of off-chain funds. If such proof is accepted, the user may proceed as above with
  the :sol:func:`withdraw` call to the contract to complete the operation.
*/
abstract contract Withdrawals is
    MainStorage,
    MAcceptModifications,
    MTokenQuantization,
    MTokenAssetData,
    MFreezable,
    MKeyGetters,
    MTokenTransfers
{
    event LogWithdrawalPerformed(
        uint256 ownerKey,
        uint256 assetType,
        uint256 nonQuantizedAmount,
        uint256 quantizedAmount,
        address recipient
    );

    event LogNftWithdrawalPerformed(
        uint256 ownerKey,
        uint256 assetType,
        uint256 tokenId,
        uint256 assetId,
        address recipient
    );

    event LogWithdrawalWithTokenIdPerformed(
        uint256 ownerKey,
        uint256 assetType,
        uint256 tokenId,
        uint256 assetId,
        uint256 nonQuantizedAmount,
        uint256 quantizedAmount,
        address recipient
    );

    event LogMintWithdrawalPerformed(
        uint256 ownerKey,
        uint256 assetType,
        uint256 nonQuantizedAmount,
        uint256 quantizedAmount,
        uint256 assetId
    );

    function getWithdrawalBalance(uint256 ownerKey, uint256 assetId)
        external
        view
        returns (uint256)
    {
        uint256 presumedAssetType = assetId;
        return fromQuantized(presumedAssetType, pendingWithdrawals[ownerKey][assetId]);
    }

    /*
      Moves funds from the pending withdrawal account to the owner address.
      Note: this function can be called by anyone.
      Can be called normally while frozen.
    */
    function withdraw(uint256 ownerKey, uint256 assetType) external {
        address payable recipient = payable(strictGetEthKey(ownerKey));
        require(!isMintableAssetType(assetType), "MINTABLE_ASSET_TYPE");
        require(isFungibleAssetType(assetType), "NON_FUNGIBLE_ASSET_TYPE");
        uint256 assetId = assetType;
        // Fetch and clear quantized amount.
        uint256 quantizedAmount = pendingWithdrawals[ownerKey][assetId];
        pendingWithdrawals[ownerKey][assetId] = 0;

        // Transfer funds.
        transferOut(recipient, assetType, quantizedAmount);
        emit LogWithdrawalPerformed(
            ownerKey,
            assetType,
            fromQuantized(assetType, quantizedAmount),
            quantizedAmount,
            recipient
        );
    }

    /*
      Allows withdrawal of tokens to their owner's account.
      Note: this function can be called by anyone.
      This function can be called normally while frozen.
    */
    function withdrawWithTokenId(
        uint256 ownerKey,
        uint256 assetType,
        uint256 tokenId // No notFrozen modifier: This function can always be used, even when frozen.
    ) public {
        require(isAssetTypeWithTokenId(assetType), "INVALID_ASSET_TYPE");
        uint256 assetId = calculateAssetIdWithTokenId(assetType, tokenId);
        address recipient = strictGetEthKey(ownerKey);

        uint256 quantizedAmount = pendingWithdrawals[ownerKey][assetId];
        pendingWithdrawals[ownerKey][assetId] = 0;

        // Transfer funds.
        transferOutWithTokenId(recipient, assetType, tokenId, quantizedAmount);
        if (isERC721(assetType)) {
            emit LogNftWithdrawalPerformed(ownerKey, assetType, tokenId, assetId, recipient);
        }
        emit LogWithdrawalWithTokenIdPerformed(
            ownerKey,
            assetType,
            tokenId,
            assetId,
            fromQuantized(assetType, quantizedAmount),
            quantizedAmount,
            recipient
        );
    }

    /*
      Allows withdrawal of an NFT to its owner's account.
      Note: this function can be called by anyone.
      This function can be called normally while frozen.
    */
    function withdrawNft(
        uint256 ownerKey,
        uint256 assetType,
        uint256 tokenId // No notFrozen modifier: This function can always be used, even when frozen.
    ) external {
        withdrawWithTokenId(ownerKey, assetType, tokenId);
    }

    function withdrawAndMint(
        uint256 ownerKey,
        uint256 assetType,
        bytes calldata mintingBlob
    ) external {
        address recipient = strictGetEthKey(ownerKey);
        require(registeredAssetType[assetType], "INVALID_ASSET_TYPE");
        require(isMintableAssetType(assetType), "NON_MINTABLE_ASSET_TYPE");
        uint256 assetId = calculateMintableAssetId(assetType, mintingBlob);
        require(pendingWithdrawals[ownerKey][assetId] > 0, "NO_PENDING_WITHDRAWAL_BALANCE");
        uint256 quantizedAmount = pendingWithdrawals[ownerKey][assetId];
        pendingWithdrawals[ownerKey][assetId] = 0;
        // Transfer funds.
        transferOutMint(assetType, quantizedAmount, recipient, mintingBlob);
        emit LogMintWithdrawalPerformed(
            ownerKey,
            assetType,
            fromQuantized(assetType, quantizedAmount),
            quantizedAmount,
            assetId
        );
    }
}
