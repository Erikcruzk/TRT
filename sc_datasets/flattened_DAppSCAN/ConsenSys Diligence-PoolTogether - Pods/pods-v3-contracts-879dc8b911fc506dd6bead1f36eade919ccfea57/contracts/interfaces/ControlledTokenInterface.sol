// File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
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

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-PoolTogether - Pods/pods-v3-contracts-879dc8b911fc506dd6bead1f36eade919ccfea57/contracts/interfaces/TokenControllerInterface.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

/// @title Controlled ERC20 Token Interface
/// @notice Required interface for Controlled ERC20 Tokens linked to a Prize Pool
/// @dev Defines the spec required to be implemented by a Controlled ERC20 Token
interface TokenControllerInterface {
    /// @dev Controller hook to provide notifications & rule validations on token transfers to the controller.
    /// This includes minting and burning.
    /// @param from Address of the account sending the tokens (address(0x0) on minting)
    /// @param to Address of the account receiving the tokens (address(0x0) on burning)
    /// @param amount Amount of tokens being transferred
    function beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) external;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-PoolTogether - Pods/pods-v3-contracts-879dc8b911fc506dd6bead1f36eade919ccfea57/contracts/interfaces/ControlledTokenInterface.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

/// @title Controlled ERC20 Token
/// @notice ERC20 Tokens with a controller for minting & burning
interface ControlledTokenInterface is IERC20Upgradeable {
    /// @notice Interface to the contract responsible for controlling mint/burn
    function controller() external view returns (TokenControllerInterface);

    /// @notice Allows the controller to mint tokens for a user account
    /// @dev May be overridden to provide more granular control over minting
    /// @param _user Address of the receiver of the minted tokens
    /// @param _amount Amount of tokens to mint
    function controllerMint(address _user, uint256 _amount) external;

    /// @notice Allows the controller to burn tokens from a user account
    /// @dev May be overridden to provide more granular control over burning
    /// @param _user Address of the holder account to burn tokens from
    /// @param _amount Amount of tokens to burn
    function controllerBurn(address _user, uint256 _amount) external;

    /// @notice Allows an operator via the controller to burn tokens on behalf of a user account
    /// @dev May be overridden to provide more granular control over operator-burning
    /// @param _operator Address of the operator performing the burn action via the controller contract
    /// @param _user Address of the holder account to burn tokens from
    /// @param _amount Amount of tokens to burn
    function controllerBurnFrom(
        address _operator,
        address _user,
        uint256 _amount
    ) external;
}
