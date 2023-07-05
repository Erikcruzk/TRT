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

// File: ../sc_datasets/DAppSCAN/openzeppelin-Ribbon_Finance/ribbon-v2-3fa3bec15ad1e2b18ad87f979b87a68368497f13/contracts/interfaces/IGnosisAuction.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;
pragma experimental ABIEncoderV2;

library AuctionType {
    struct AuctionData {
        IERC20 auctioningToken;
        IERC20 biddingToken;
        uint256 orderCancellationEndDate;
        uint256 auctionEndDate;
        bytes32 initialAuctionOrder;
        uint256 minimumBiddingAmountPerOrder;
        uint256 interimSumBidAmount;
        bytes32 interimOrder;
        bytes32 clearingPriceOrder;
        uint96 volumeClearingPriceOrder;
        bool minFundingThresholdNotReached;
        bool isAtomicClosureAllowed;
        uint256 feeNumerator;
        uint256 minFundingThreshold;
    }
}

interface IGnosisAuction {
    function initiateAuction(
        address _auctioningToken,
        address _biddingToken,
        uint256 orderCancellationEndDate,
        uint256 auctionEndDate,
        uint96 _auctionedSellAmount,
        uint96 _minBuyAmount,
        uint256 minimumBiddingAmountPerOrder,
        uint256 minFundingThreshold,
        bool isAtomicClosureAllowed,
        address accessManagerContract,
        bytes memory accessManagerContractData
    ) external returns (uint256);

    function auctionCounter() external view returns (uint256);

    function auctionData(uint256 auctionId)
        external
        view
        returns (AuctionType.AuctionData memory);

    function auctionAccessManager(uint256 auctionId)
        external
        view
        returns (address);

    function auctionAccessData(uint256 auctionId)
        external
        view
        returns (bytes memory);

    function FEE_DENOMINATOR() external view returns (uint256);

    function feeNumerator() external view returns (uint256);

    function settleAuction(uint256 auctionId) external returns (bytes32);

    function placeSellOrders(
        uint256 auctionId,
        uint96[] memory _minBuyAmounts,
        uint96[] memory _sellAmounts,
        bytes32[] memory _prevSellOrders,
        bytes calldata allowListCallData
    ) external returns (uint64);

    function claimFromParticipantOrder(
        uint256 auctionId,
        bytes32[] memory orders
    ) external returns (uint256, uint256);
}
