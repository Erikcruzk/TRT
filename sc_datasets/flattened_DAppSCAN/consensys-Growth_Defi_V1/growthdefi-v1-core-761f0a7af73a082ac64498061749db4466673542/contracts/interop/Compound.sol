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

// File: ../sc_datasets/DAppSCAN/consensys-Growth_Defi_V1/growthdefi-v1-core-761f0a7af73a082ac64498061749db4466673542/contracts/interop/Compound.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @dev Minimal set of declarations for Compound interoperability.
 */
interface Comptroller
{
	function oracle() external view returns (address _oracle);
	function enterMarkets(address[] calldata _ctokens) external returns (uint256[] memory _errorCodes);
	function markets(address _ctoken) external view returns (bool _isListed, uint256 _collateralFactorMantissa);
	function getAccountLiquidity(address _account) external view returns (uint256 _error, uint256 _liquidity, uint256 _shortfall);
}

interface CPriceOracle
{
	function getUnderlyingPrice(address _ctoken) external view returns (uint256 _price);
}

interface CToken is IERC20
{
	function underlying() external view returns (address _token);
	function exchangeRateStored() external view returns (uint256 _exchangeRate);
	function borrowBalanceStored(address _account) external view returns (uint256 _borrowBalance);
	function exchangeRateCurrent() external returns (uint256 _exchangeRate);
	function getCash() external view returns (uint256 _cash);
	function borrowBalanceCurrent(address _account) external returns (uint256 _borrowBalance);
	function balanceOfUnderlying(address _owner) external returns (uint256 _underlyingBalance);
	function mint() external payable;
	function mint(uint256 _mintAmount) external returns (uint256 _errorCode);
	function repayBorrow() external payable;
	function repayBorrow(uint256 _repayAmount) external returns (uint256 _errorCode);
	function redeemUnderlying(uint256 _redeemAmount) external returns (uint256 _errorCode);
	function borrow(uint256 _borrowAmount) external returns (uint256 _errorCode);
}
