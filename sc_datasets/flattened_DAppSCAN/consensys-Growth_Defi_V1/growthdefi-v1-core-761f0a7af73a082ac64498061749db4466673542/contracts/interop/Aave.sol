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

// File: ../sc_datasets/DAppSCAN/consensys-Growth_Defi_V1/growthdefi-v1-core-761f0a7af73a082ac64498061749db4466673542/contracts/interop/Aave.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @dev Minimal set of declarations for Aave interoperability.
 */
interface LendingPoolAddressesProvider
{
	function getLendingPool() external view returns (address _pool);
	function getLendingPoolCore() external view returns (address payable _lendingPoolCore);
	function getPriceOracle() external view returns (address _priceOracle);
}

interface LendingPool
{
	function getReserveConfigurationData(address _reserve) external view returns (uint256 _ltv, uint256 _liquidationThreshold, uint256 _liquidationBonus, address _interestRateStrategyAddress, bool _usageAsCollateralEnabled, bool _borrowingEnabled, bool _stableBorrowRateEnabled, bool _isActive);
	function getUserAccountData(address _user) external view returns (uint256 _totalLiquidityETH, uint256 _totalCollateralETH, uint256 _totalBorrowsETH, uint256 _totalFeesETH, uint256 _availableBorrowsETH, uint256 _currentLiquidationThreshold, uint256 _ltv, uint256 _healthFactor);
	function getUserReserveData(address _reserve, address _user) external view returns (uint256 _currentATokenBalance, uint256 _currentBorrowBalance, uint256 _principalBorrowBalance, uint256 _borrowRateMode, uint256 _borrowRate, uint256 _liquidityRate, uint256 _originationFee, uint256 _variableBorrowIndex, uint256 _lastUpdateTimestamp, bool _usageAsCollateralEnabled);
	function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external payable;
	function borrow(address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode) external;
	function repay(address _reserve, uint256 _amount, address payable _onBehalfOf) external payable;
	function flashLoan(address _receiver, address _reserve, uint256 _amount, bytes calldata _params) external;
}

interface LendingPoolCore
{
	function getReserveDecimals(address _reserve) external view returns (uint256 _decimals);
	function getReserveAvailableLiquidity(address _reserve) external view returns (uint256 _availableLiquidity);
}

interface AToken is IERC20
{
	function underlyingAssetAddress() external view returns (address _underlyingAssetAddress);
	function redeem(uint256 _amount) external;
}

interface APriceOracle
{
	function getAssetPrice(address _asset) external view returns (uint256 _assetPrice);
}

interface FlashLoanReceiver
{
	function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;
}
