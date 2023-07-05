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
