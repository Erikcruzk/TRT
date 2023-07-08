// File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)

pragma solidity ^0.8.0;

/**
 * @dev These functions deal with verification of Merkle Tree proofs.
 *
 * The tree and the proofs can be generated using our
 * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
 * You will find a quickstart guide in the readme.
 *
 * WARNING: You should avoid using leaf values that are 64 bytes long prior to
 * hashing, or use a hash function other than keccak256 for hashing leaves.
 * This is because the concatenation of a sorted pair of internal nodes in
 * the merkle tree could be reinterpreted as a leaf value.
 * OpenZeppelin's JavaScript library generates merkle trees that are safe
 * against this attack out of the box.
 */
library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Calldata version of {verify}
     *
     * _Available since v4.7._
     */
    function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProofCalldata(proof, leaf) == root;
    }

    /**
     * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
     * hash matches the root of the tree. When processing the proof, the pairs
     * of leafs & pre-images are assumed to be sorted.
     *
     * _Available since v4.4._
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Calldata version of {processProof}
     *
     * _Available since v4.7._
     */
    function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
     * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function multiProofVerify(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProof(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Calldata version of {multiProofVerify}
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function multiProofVerifyCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProofCalldata(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
     * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
     * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
     * respectively.
     *
     * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
     * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
     * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
     *
     * _Available since v4.7._
     */
    function processMultiProof(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 proofLen = proof.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i]
                ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
                : proof[proofPos++];
            hashes[i] = _hashPair(a, b);
        }

        if (totalHashes > 0) {
            require(proofPos == proofLen, "MerkleProof: invalid multiproof");
            unchecked {
                return hashes[totalHashes - 1];
            }
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }

    /**
     * @dev Calldata version of {processMultiProof}.
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function processMultiProofCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 proofLen = proof.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i]
                ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
                : proof[proofPos++];
            hashes[i] = _hashPair(a, b);
        }

        if (totalHashes > 0) {
            require(proofPos == proofLen, "MerkleProof: invalid multiproof");
            unchecked {
                return hashes[totalHashes - 1];
            }
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA_Across_V2/contracts-v2-bf03255cbd1db3045cd2fbf1580f24081f46b43a/contracts/SpokePoolInterface.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @notice Contains common data structures and functions used by all SpokePool implementations.
 */
interface SpokePoolInterface {
    // This leaf is meant to be decoded in the SpokePool to pay out successful relayers.
    struct RelayerRefundLeaf {
        // This is the amount to return to the HubPool. This occurs when there is a PoolRebalanceLeaf netSendAmount that is
        // negative. This is just that value inverted.
        uint256 amountToReturn;
        // Used to verify that this is being executed on the correct destination chainId.
        uint256 chainId;
        // This array designates how much each of those addresses should be refunded.
        uint256[] refundAmounts;
        // Used as the index in the bitmap to track whether this leaf has been executed or not.
        uint32 leafId;
        // The associated L2TokenAddress that these claims apply to.
        address l2TokenAddress;
        // Must be same length as refundAmounts and designates each address that must be refunded.
        address[] refundAddresses;
    }

    // This struct represents the data to fully specify a relay. If any portion of this data differs, the relay is
    // considered to be completely distinct. Only one relay for a particular depositId, chainId pair should be
    // considered valid and repaid. This data is hashed and inserted into a the slow relay merkle root so that an off
    // chain validator can choose when to refund slow relayers.
    struct RelayData {
        // The address that made the deposit on the origin chain.
        address depositor;
        // The recipient address on the destination chain.
        address recipient;
        // The corresponding token address on the destination chain.
        address destinationToken;
        // The total relay amount before fees are taken out.
        uint256 amount;
        // Origin chain id.
        uint256 originChainId;
        // The LP Fee percentage computed by the relayer based on the deposit's quote timestamp
        // and the HubPool's utilization.
        uint64 realizedLpFeePct;
        // The relayer fee percentage specified in the deposit.
        uint64 relayerFeePct;
        // The id uniquely identifying this deposit on the origin chain.
        uint32 depositId;
    }

    function setCrossDomainAdmin(address newCrossDomainAdmin) external;

    function setHubPool(address newHubPool) external;

    function setEnableRoute(
        address originToken,
        uint256 destinationChainId,
        bool enable
    ) external;

    function setDepositQuoteTimeBuffer(uint32 buffer) external;

    function relayRootBundle(bytes32 relayerRefundRoot, bytes32 slowRelayRoot) external;

    function deposit(
        address recipient,
        address originToken,
        uint256 amount,
        uint256 destinationChainId,
        uint64 relayerFeePct,
        uint32 quoteTimestamp
    ) external payable;

    function speedUpDeposit(
        address depositor,
        uint64 newRelayerFeePct,
        uint32 depositId,
        bytes memory depositorSignature
    ) external;

    function fillRelay(
        address depositor,
        address recipient,
        address destinationToken,
        uint256 amount,
        uint256 maxTokensToSend,
        uint256 repaymentChainId,
        uint256 originChainId,
        uint64 realizedLpFeePct,
        uint64 relayerFeePct,
        uint32 depositId
    ) external;

    function fillRelayWithUpdatedFee(
        address depositor,
        address recipient,
        address destinationToken,
        uint256 amount,
        uint256 maxTokensToSend,
        uint256 repaymentChainId,
        uint256 originChainId,
        uint64 realizedLpFeePct,
        uint64 relayerFeePct,
        uint64 newRelayerFeePct,
        uint32 depositId,
        bytes memory depositorSignature
    ) external;

    function executeSlowRelayRoot(
        address depositor,
        address recipient,
        address destinationToken,
        uint256 amount,
        uint256 originChainId,
        uint64 realizedLpFeePct,
        uint64 relayerFeePct,
        uint32 depositId,
        uint32 rootBundleId,
        bytes32[] memory proof
    ) external;

    function executeRelayerRefundRoot(
        uint32 rootBundleId,
        SpokePoolInterface.RelayerRefundLeaf memory relayerRefundLeaf,
        bytes32[] memory proof
    ) external;

    function chainId() external view returns (uint256);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA_Across_V2/contracts-v2-bf03255cbd1db3045cd2fbf1580f24081f46b43a/contracts/interfaces/AdapterInterface.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @notice Sends cross chain messages and tokens to contracts on a specific L2 network.
 */

interface AdapterInterface {
    event HubPoolChanged(address newHubPool);

    event MessageRelayed(address target, bytes message);

    event TokensRelayed(address l1Token, address l2Token, uint256 amount, address to);

    function relayMessage(address target, bytes memory message) external payable;

    function relayTokens(
        address l1Token,
        address l2Token,
        uint256 amount,
        address to
    ) external payable;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA_Across_V2/contracts-v2-bf03255cbd1db3045cd2fbf1580f24081f46b43a/contracts/HubPoolInterface.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;


/**
 * @notice Concise list of functions in HubPool implementation.
 */
interface HubPoolInterface {
    // This leaf is meant to be decoded in the HubPool to rebalance tokens between HubPool and SpokePool.
    struct PoolRebalanceLeaf {
        // This is used to know which chain to send cross-chain transactions to (and which SpokePool to sent to).
        uint256 chainId;
        // Total LP fee amount per token in this bundle, encompassing all associated bundled relays.
        uint256[] bundleLpFees;
        // This array is grouped with the two above, and it represents the amount to send or request back from the
        // SpokePool. If positive, the pool will pay the SpokePool. If negative the SpokePool will pay the HubPool.
        // There can be arbitrarily complex rebalancing rules defined offchain. This number is only nonzero
        // when the rules indicate that a rebalancing action should occur. When a rebalance does not occur,
        // runningBalances for this token should change by the total relays - deposits in this bundle. When a rebalance
        // does occur, runningBalances should be set to zero for this token and the netSendAmounts should be set to the
        // previous runningBalances + relays - deposits in this bundle.
        int256[] netSendAmounts;
        // This is only here to be emitted in an event to track a running unpaid balance between the L2 pool and the L1 pool.
        // A positive number indicates that the HubPool owes the SpokePool funds. A negative number indicates that the
        // SpokePool owes the HubPool funds. See the comment above for the dynamics of this and netSendAmounts
        int256[] runningBalances;
        // Used as the index in the bitmap to track whether this leaf has been executed or not.
        uint8 leafId;
        // The following arrays are required to be the same length. They are parallel arrays for the given chainId and
        // should be ordered by the l1Tokens field. All whitelisted tokens with nonzero relays on this chain in this
        // bundle in the order of whitelisting.
        address[] l1Tokens;
    }

    function relaySpokePoolAdminFunction(uint256 chainId, bytes memory functionData) external;

    function setProtocolFeeCapture(address newProtocolFeeCaptureAddress, uint256 newProtocolFeeCapturePct) external;

    function setBond(IERC20 newBondToken, uint256 newBondAmount) external;

    function setLiveness(uint64 newLiveness) external;

    function setIdentifier(bytes32 newIdentifier) external;

    function setCrossChainContracts(
        uint256 l2ChainId,
        address adapter,
        address spokePool
    ) external;

    function whitelistRoute(
        uint256 originChainId,
        uint256 destinationChainId,
        address originToken,
        address destinationToken
    ) external;

    function enableL1TokenForLiquidityProvision(address l1Token) external;

    function disableL1TokenForLiquidityProvision(address l1Token) external;

    function addLiquidity(address l1Token, uint256 l1TokenAmount) external payable;

    function removeLiquidity(
        address l1Token,
        uint256 lpTokenAmount,
        bool sendEth
    ) external;

    function exchangeRateCurrent(address l1Token) external returns (uint256);

    function liquidityUtilizationCurrent(address l1Token) external returns (uint256);

    function liquidityUtilizationPostRelay(address token, uint256 relayedAmount) external returns (uint256);

    function sync(address l1Token) external;

    function proposeRootBundle(
        uint256[] memory bundleEvaluationBlockNumbers,
        uint8 poolRebalanceLeafCount,
        bytes32 poolRebalanceRoot,
        bytes32 relayerRefundRoot,
        bytes32 slowRelayRoot
    ) external;

    function executeRootBundle(PoolRebalanceLeaf memory poolRebalanceLeaf, bytes32[] memory proof) external;

    function disputeRootBundle() external;

    function claimProtocolFeesCaptured(address l1Token) external;

    function getRootBundleProposalAncillaryData() external view returns (bytes memory ancillaryData);

    function whitelistedRoute(
        uint256 originChainId,
        address originToken,
        uint256 destinationChainId
    ) external view returns (address);

    function loadEthForL2Calls() external payable;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA_Across_V2/contracts-v2-bf03255cbd1db3045cd2fbf1580f24081f46b43a/contracts/MerkleLib.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;



/**
 * @notice Library to help with merkle roots, proofs, and claims.
 */
library MerkleLib {
    /**
     * @notice Verifies that a repayment is contained within a merkle root.
     * @param root the merkle root.
     * @param rebalance the rebalance struct.
     * @param proof the merkle proof.
     */
    function verifyPoolRebalance(
        bytes32 root,
        HubPoolInterface.PoolRebalanceLeaf memory rebalance,
        bytes32[] memory proof
    ) internal pure returns (bool) {
        return MerkleProof.verify(proof, root, keccak256(abi.encode(rebalance)));
    }

    /**
     * @notice Verifies that a relayer refund is contained within a merkle root.
     * @param root the merkle root.
     * @param refund the refund struct.
     * @param proof the merkle proof.
     */
    function verifyRelayerRefund(
        bytes32 root,
        SpokePoolInterface.RelayerRefundLeaf memory refund,
        bytes32[] memory proof
    ) internal pure returns (bool) {
        return MerkleProof.verify(proof, root, keccak256(abi.encode(refund)));
    }

    /**
     * @notice Verifies that a distribution is contained within a merkle root.
     * @param root the merkle root.
     * @param slowRelayFulfillment the relayData fulfullment struct.
     * @param proof the merkle proof.
     */
    function verifySlowRelayFulfillment(
        bytes32 root,
        SpokePoolInterface.RelayData memory slowRelayFulfillment,
        bytes32[] memory proof
    ) internal pure returns (bool) {
        return MerkleProof.verify(proof, root, keccak256(abi.encode(slowRelayFulfillment)));
    }

    // The following functions are primarily copied from
    // https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol with minor changes.

    /**
     * @notice Tests whether a claim is contained within a claimedBitMap mapping.
     * @param claimedBitMap a simple uint256 mapping in storage used as a bitmap.
     * @param index the index to check in the bitmap.
     * @return bool indicating if the index within the claimedBitMap has been marked as claimed.
     */
    function isClaimed(mapping(uint256 => uint256) storage claimedBitMap, uint256 index) internal view returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    /**
     * @notice Marks an index in a claimedBitMap as claimed.
     * @param claimedBitMap a simple uint256 mapping in storage used as a bitmap.
     * @param index the index to mark in the bitmap.
     */
    function setClaimed(mapping(uint256 => uint256) storage claimedBitMap, uint256 index) internal {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    /**
     * @notice Tests whether a claim is contained within a 1D claimedBitMap mapping.
     * @param claimedBitMap a simple uint256 value, encoding a 1D bitmap.
     * @param index the index to check in the bitmap.
     \* @return bool indicating if the index within the claimedBitMap has been marked as claimed.
     */
    function isClaimed1D(uint256 claimedBitMap, uint256 index) internal pure returns (bool) {
        uint256 mask = (1 << index);
        return claimedBitMap & mask == mask;
    }

    /**
     * @notice Marks an index in a claimedBitMap as claimed.
     * @param claimedBitMap a simple uint256 mapping in storage used as a bitmap.
     * @param index the index to mark in the bitmap.
     */
    function setClaimed1D(uint256 claimedBitMap, uint256 index) internal pure returns (uint256) {
        require(index <= 255, "Index out of bounds");
        return claimedBitMap | (1 << index % 256);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA_Across_V2/contracts-v2-bf03255cbd1db3045cd2fbf1580f24081f46b43a/contracts/test/MerkleLibTest.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;



/**
 * @notice Contract to test the MerkleLib.
 */
contract MerkleLibTest {
    mapping(uint256 => uint256) public claimedBitMap;

    uint256 public claimedBitMap1D;

    function verifyPoolRebalance(
        bytes32 root,
        HubPoolInterface.PoolRebalanceLeaf memory rebalance,
        bytes32[] memory proof
    ) public pure returns (bool) {
        return MerkleLib.verifyPoolRebalance(root, rebalance, proof);
    }

    function verifyRelayerRefund(
        bytes32 root,
        SpokePoolInterface.RelayerRefundLeaf memory refund,
        bytes32[] memory proof
    ) public pure returns (bool) {
        return MerkleLib.verifyRelayerRefund(root, refund, proof);
    }

    function verifySlowRelayFulfillment(
        bytes32 root,
        SpokePoolInterface.RelayData memory slowRelayFulfillment,
        bytes32[] memory proof
    ) public pure returns (bool) {
        return MerkleLib.verifySlowRelayFulfillment(root, slowRelayFulfillment, proof);
    }

    function isClaimed(uint256 index) public view returns (bool) {
        return MerkleLib.isClaimed(claimedBitMap, index);
    }

    function setClaimed(uint256 index) public {
        MerkleLib.setClaimed(claimedBitMap, index);
    }

    function isClaimed1D(uint256 index) public view returns (bool) {
        return MerkleLib.isClaimed1D(claimedBitMap1D, index);
    }

    function setClaimed1D(uint256 index) public {
        claimedBitMap1D = MerkleLib.setClaimed1D(claimedBitMap1D, index);
    }
}
