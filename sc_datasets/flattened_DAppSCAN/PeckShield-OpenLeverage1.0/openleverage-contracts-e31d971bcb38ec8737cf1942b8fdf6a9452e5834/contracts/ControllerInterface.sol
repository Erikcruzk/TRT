// File: ../sc_datasets/DAppSCAN/PeckShield-OpenLeverage1.0/openleverage-contracts-e31d971bcb38ec8737cf1942b8fdf6a9452e5834/contracts/liquidity/LPoolInterface.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.7.6;


abstract contract LPoolStorage {

    //Guard variable for re-entrancy checks
    bool internal _notEntered;

    /**
     * EIP-20 token name for this token
     */
    string public name;

    /**
     * EIP-20 token symbol for this token
     */
    string public symbol;

    /**
     * EIP-20 token decimals for this token
     */
    uint8 public decimals;

    /**
    * Total number of tokens in circulation
    */
    uint public totalSupply;


    //Official record of token balances for each account
    mapping(address => uint) internal accountTokens;

    //Approved token transfer amounts on behalf of others
    mapping(address => mapping(address => uint)) internal transferAllowances;


    //Maximum borrow rate that can ever be applied (.0005% / block)
    uint internal constant borrowRateMaxMantissa = 0.0005e16;

    /**
    * Maximum fraction of borrower cap(80%)
    */
    uint public  borrowCapFactorMantissa;
    /**
     * Contract which oversees inter-lToken operations
     */
    address public controller;


    // Initial exchange rate used when minting the first lTokens (used when totalSupply = 0)
    uint internal initialExchangeRateMantissa;

    /**
     * Block number that interest was last accrued at
     */
    uint public accrualBlockNumber;

    /**
     * Accumulator of the total earned interest rate since the opening of the market
     */
    uint public borrowIndex;

    /**
     * Total amount of outstanding borrows of the underlying in this market
     */
    uint public totalBorrows;

    /**
    * @notice Fraction of interest currently set aside for reserves 20%
    */
    uint public reserveFactorMantissa;


    uint public totalReserves;


    address public underlying;

    bool public isWethPool;

    /**
     * Container for borrow balance information
     * principal Total balance (with accrued interest), after applying the most recent balance-changing action
     * interestIndex Global borrowIndex as of the most recent balance-changing action
     */
    struct BorrowSnapshot {
        uint principal;
        uint interestIndex;
    }

    uint256 public baseRatePerBlock;
    uint256 public multiplierPerBlock;
    uint256 public jumpMultiplierPerBlock;
    uint256 public kink;

    // Mapping of account addresses to outstanding borrow balances

    mapping(address => BorrowSnapshot) internal accountBorrows;


    /*** Token Events ***/

    /**
    * Event emitted when tokens are minted
    */
    event Mint(address minter, uint mintAmount, uint mintTokens);

    /**
     * EIP20 Transfer event
     */
    event Transfer(address indexed from, address indexed to, uint amount);

    /**
     * EIP20 Approval event
     */
    event Approval(address indexed owner, address indexed spender, uint amount);

    /*** Market Events ***/

    /**
     * Event emitted when interest is accrued
     */
    event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);

    /**
     * Event emitted when tokens are redeemed
     */
    event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);

    /**
     * Event emitted when underlying is borrowed
     */
    event Borrow(address borrower, address payee, uint borrowAmount, uint accountBorrows, uint totalBorrows);

    /**
     * Event emitted when a borrow is repaid
     */
    event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);

    /*** Admin Events ***/

    /**
     * Event emitted when controller is changed
     */
    event NewController(address oldController, address newController);

    /**
     * Event emitted when interestParam is changed
     */
    event NewInterestParam(uint baseRatePerBlock, uint multiplierPerBlock, uint jumpMultiplierPerBlock, uint kink);

    /**
    * @notice Event emitted when the reserve factor is changed
    */
    event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);

    /**
     * @notice Event emitted when the reserves are added
     */
    event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);

    /**
     * @notice Event emitted when the reserves are reduced
     */
    event ReservesReduced(address to, uint reduceAmount, uint newTotalReserves);


}

abstract contract LPoolInterface is LPoolStorage {


    /*** User Interface ***/

    function transfer(address dst, uint amount) external virtual returns (bool);

    function transferFrom(address src, address dst, uint amount) external virtual returns (bool);

    function approve(address spender, uint amount) external virtual returns (bool);

    function allowance(address owner, address spender) external virtual view returns (uint);

    function balanceOf(address owner) external virtual view returns (uint);

    function balanceOfUnderlying(address owner) external virtual returns (uint);

    /*** Lender & Borrower Functions ***/

    function mint(uint mintAmount) external virtual;

    function mintEth() external payable virtual;

    function redeem(uint redeemTokens) external virtual;

    function redeemUnderlying(uint redeemAmount) external virtual;

    function borrowBehalf(address borrower, uint borrowAmount) external virtual;

    function repayBorrowBehalf(address borrower, uint repayAmount) external virtual;

    function repayBorrowEndByOpenLev(address borrower, uint repayAmount) external virtual;

    function availableForBorrow() external view virtual returns (uint);

    function getAccountSnapshot(address account) external virtual view returns (uint, uint, uint);

    function borrowRatePerBlock() external virtual view returns (uint);

    function supplyRatePerBlock() external virtual view returns (uint);

    function totalBorrowsCurrent() external virtual view returns (uint);

    function borrowBalanceCurrent(address account) external virtual view returns (uint);

    function borrowBalanceStored(address account) external virtual view returns (uint);

    function exchangeRateCurrent() public virtual returns (uint);

    function exchangeRateStored() public virtual view returns (uint);

    function getCash() external view virtual returns (uint);

    function accrueInterest() public virtual;


    /*** Admin Functions ***/

    function setController(address newController) external virtual;

    function setBorrowCapFactorMantissa(uint newBorrowCapFactorMantissa) external virtual;

    function setInterestParams(uint baseRatePerBlock_, uint multiplierPerBlock_, uint jumpMultiplierPerBlock_, uint kink_) external virtual;

    function setReserveFactor(uint newReserveFactorMantissa) external virtual;

    function addReserves(uint addAmount) external virtual;

    function reduceReserves(address payable to, uint reduceAmount) external virtual;

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

// File: ../sc_datasets/DAppSCAN/PeckShield-OpenLeverage1.0/openleverage-contracts-e31d971bcb38ec8737cf1942b8fdf6a9452e5834/contracts/dex/DexAggregatorInterface.sol

// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

interface DexAggregatorInterface {

    function sell(address buyToken, address sellToken, uint sellAmount, uint minBuyAmount, bytes memory data) external returns (uint buyAmount);

    function sellMul(uint sellAmount, uint minBuyAmount, bytes memory data) external returns (uint buyAmount);

    function buy(address buyToken, address sellToken, uint buyAmount, uint maxSellAmount, bytes memory data) external returns (uint sellAmount);

    function calBuyAmount(address buyToken, address sellToken, uint sellAmount, bytes memory data) external view returns (uint);

    function getPrice(address desToken, address quoteToken, bytes memory data) external view returns (uint256 price, uint8 decimals);

    function getAvgPrice(address desToken, address quoteToken, uint32 secondsAgo, bytes memory data) external view returns (uint256 price, uint8 decimals, uint256 timestamp);

    //cal current avg price and get history avg price
    function getPriceCAvgPriceHAvgPrice(address desToken, address quoteToken, uint32 secondsAgo, bytes memory dexData) external view returns (uint price, uint cAvgPrice, uint256 hAvgPrice, uint8 decimals, uint256 timestamp);

    function updatePriceOracle(address desToken, address quoteToken, uint32 timeWindow, bytes memory data) external returns(bool);

    function updateV3Observation(address desToken, address quoteToken, bytes memory data) external;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OpenLeverage1.0/openleverage-contracts-e31d971bcb38ec8737cf1942b8fdf6a9452e5834/contracts/ControllerInterface.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.7.6;

pragma experimental ABIEncoderV2;



contract ControllerStorage {

    //lpool-pair
    struct LPoolPair {
        address lpool0;
        address lpool1;
    }
    //lpool-distribution
    struct LPoolDistribution {
        uint64 startTime;
        uint64 endTime;
        uint64 duration;
        uint64 lastUpdateTime;
        uint256 totalRewardAmount;
        uint256 rewardRate;
        uint256 rewardPerTokenStored;
        uint256 extraTotalToken;
    }
    //lpool-rewardByAccount
    struct LPoolRewardByAccount {
        uint rewardPerTokenStored;
        uint rewards;
        uint extraToken;
    }

    struct OLETokenDistribution {
        uint supplyBorrowBalance;
        uint extraBalance;
        uint128 updatePricePer;
        uint128 liquidatorMaxPer;
        uint16 liquidatorOLERatio;//300=>300%
        uint16 xoleRaiseRatio;//150=>150%
        uint128 xoleRaiseMinAmount;
    }

    IERC20 public oleToken;

    address public xoleToken;

    address public wETH;

    address public lpoolImplementation;

    //interest param
    uint256 public baseRatePerBlock;
    uint256 public multiplierPerBlock;
    uint256 public jumpMultiplierPerBlock;
    uint256 public kink;

    address public openLev;

    DexAggregatorInterface public dexAggregator;

    bool public suspend;

    OLETokenDistribution public oleTokenDistribution;
    //token0=>token1=>pair
    mapping(address => mapping(address => LPoolPair)) public lpoolPairs;
    //marketId=>isDistribution
    mapping(uint => bool) public marketExtraDistribution;
    //pool=>allowed
    mapping(address => bool) public lpoolUnAlloweds;
    //pool=>bool=>distribution(true is borrow,false is supply)
    mapping(LPoolInterface => mapping(bool => LPoolDistribution)) public lpoolDistributions;
    //pool=>bool=>distribution(true is borrow,false is supply)
    mapping(LPoolInterface => mapping(bool => mapping(address => LPoolRewardByAccount))) public lPoolRewardByAccounts;

    event LPoolPairCreated(address token0, address pool0, address token1, address pool1, uint16 marketId, uint16 marginLimit, bytes dexData);

    event Distribution2Pool(address pool, uint supplyAmount, uint borrowerAmount, uint64 startTime, uint64 duration);

}
/**
  * @title Controller
  * @author OpenLeverage
  */
interface ControllerInterface {

    function createLPoolPair(address tokenA, address tokenB, uint16 marginLimit, bytes memory dexData) external;

    /*** Policy Hooks ***/

    function mintAllowed(address lpool, address minter, uint lTokenAmount) external;

    function transferAllowed(address lpool, address from, address to, uint lTokenAmount) external;

    function redeemAllowed(address lpool, address redeemer, uint lTokenAmount) external;

    function borrowAllowed(address lpool, address borrower, address payee, uint borrowAmount) external;

    function repayBorrowAllowed(address lpool, address payer, address borrower, uint repayAmount, bool isEnd) external;

    function liquidateAllowed(uint marketId, address liquidator, uint liquidateAmount, bytes memory dexData) external;

    function marginTradeAllowed(uint marketId) external view returns (bool);

    function updatePriceAllowed(uint marketId) external;

    /*** Admin Functions ***/

    function setLPoolImplementation(address _lpoolImplementation) external;

    function setOpenLev(address _openlev) external;

    function setDexAggregator(DexAggregatorInterface _dexAggregator) external;

    function setInterestParam(uint256 _baseRatePerBlock, uint256 _multiplierPerBlock, uint256 _jumpMultiplierPerBlock, uint256 _kink) external;

    function setLPoolUnAllowed(address lpool, bool unAllowed) external;

    function setSuspend(bool suspend) external;

    // liquidatorOLERatio: Two decimal in percentage, ex. 300% => 300
    function setOLETokenDistribution(uint moreSupplyBorrowBalance, uint moreExtraBalance, uint128 updatePricePer, uint128 liquidatorMaxPer, uint16 liquidatorOLERatio, uint16 xoleRaiseRatio, uint128 xoleRaiseMinAmount) external;

    function distributeRewards2Pool(address pool, uint supplyAmount, uint borrowAmount, uint64 startTime, uint64 duration) external;

    function distributeRewards2PoolMore(address pool, uint supplyAmount, uint borrowAmount) external;

    function distributeExtraRewards2Market(uint marketId, bool isDistribution) external;

    /***Distribution Functions ***/

    function earned(LPoolInterface lpool, address account, bool isBorrow) external view returns (uint256);

    function getSupplyRewards(LPoolInterface[] calldata lpools, address account) external;

}
