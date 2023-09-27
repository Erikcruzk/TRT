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

// File: ../sc_datasets/DAppSCAN/Coinspect-Tempus Audit/tempus-protocol-ee5964bd416770e00639a4053b45f346e4bf8b93/contracts/protocols/compound/IComptroller.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

// Based on https://github.com/compound-finance/compound-protocol/blob/v2.8.1/contracts/ComptrollerInterface.sol
// and documentation at https://compound.finance/docs/comptroller
interface IComptroller {
    /// Enter into a list of markets - it is not an error to enter the same market more than once.
    /// In order to supply collateral or borrow in a market, it must be entered first.
    /// @param cTokens The list of addresses of the cToken markets to be enabled
    /// @return For each market, returns an error code indicating whether or not it was entered.
    ///         Each is 0 on success, otherwise an Error code.
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
}

// File: ../sc_datasets/DAppSCAN/Coinspect-Tempus Audit/tempus-protocol-ee5964bd416770e00639a4053b45f346e4bf8b93/contracts/protocols/compound/ICToken.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

// Based on https://github.com/compound-finance/compound-protocol/blob/v2.8.1/contracts/CToken.sol
// and https://github.com/compound-finance/compound-protocol/blob/v2.8.1/contracts/CTokenInterfaces.sol
interface ICToken is IERC20 {
    /// Indicator that this is a CToken contract (for inspection)
    function isCToken() external view returns (bool);

    /// Contract which oversees inter-cToken operations
    function comptroller() external view returns (IComptroller);

    /// Calculates and returns the current exchange rate. The value has a fixed precision of 18 decimal places.
    function exchangeRateCurrent() external returns (uint);

    /// Calculates and returns the last stored rate. The value has a fixed precision of 18 decimal places.
    function exchangeRateStored() external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Coinspect-Tempus Audit/tempus-protocol-ee5964bd416770e00639a4053b45f346e4bf8b93/contracts/protocols/compound/ICErc20.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

// Based on CErc20Interface in https://github.com/compound-finance/compound-protocol/blob/v2.8.1/contracts/CTokenInterfaces.sol
// and documentation at https://compound.finance/docs/ctokens
interface ICErc20 is ICToken {
    /// Underlying asset for this CToken
    function underlying() external view returns (address);

    /// The mint function transfers an asset into the protocol, which begins accumulating interest based
    /// on the current Supply Rate for the asset. The user receives a quantity of cTokens equal to the
    /// underlying tokens supplied, divided by the current Exchange Rate.
    /// @param mintAmount The amount of the asset to be supplied, in units of the underlying asset.
    /// @return 0 on success, otherwise an Error code
    function mint(uint mintAmount) external returns (uint);

    /// The redeem function converts a specified quantity of cTokens into the underlying asset, and returns
    /// them to the user. The amount of underlying tokens received is equal to the quantity of cTokens redeemed,
    /// multiplied by the current Exchange Rate. The amount redeemed must be less than the user's Account Liquidity
    /// and the market's available liquidity.
    /// @param redeemTokens The number of cTokens to be redeemed.
    /// @return 0 on success, otherwise an Error code
    function redeem(uint redeemTokens) external returns (uint);
}