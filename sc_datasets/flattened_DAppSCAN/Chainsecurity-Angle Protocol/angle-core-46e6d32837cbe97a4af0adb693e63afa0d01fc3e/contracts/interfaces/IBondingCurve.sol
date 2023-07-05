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

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol/angle-core-46e6d32837cbe97a4af0adb693e63afa0d01fc3e/contracts/interfaces/IAgToken.sol

// SPDX-License-Identifier: GNU GPLv3

pragma solidity ^0.8.7;

/// @title IAgToken
/// @author Angle Core Team
/// @notice Interface for the stablecoins `AgToken` contracts
/// @dev The only functions that are left in the interface are the functions which are used
/// at another point in the protocol by a different contract
interface IAgToken is IERC20Upgradeable {
    // ======================= `StableMaster` functions ============================
    function mint(address account, uint256 amount) external;

    function burnFrom(
        uint256 amount,
        address burner,
        address sender
    ) external;

    function burnSelf(uint256 amount, address burner) external;

    // ========================= External function =================================

    function stableMaster() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol/angle-core-46e6d32837cbe97a4af0adb693e63afa0d01fc3e/contracts/interfaces/IOracle.sol

// SPDX-License-Identifier: GNU GPLv3

pragma solidity ^0.8.7;

/// @title IOracle
/// @author Angle Core Team
/// @notice Interface for Angle's oracle contracts reading oracle rates from both UniswapV3 and Chainlink
/// from just UniswapV3 or from just Chainlink
interface IOracle {
    function read() external view returns (uint256);

    function readAll() external view returns (uint256 lowerRate, uint256 upperRate);

    function readLower() external view returns (uint256);

    function readUpper() external view returns (uint256);

    function readQuote(uint256 baseAmount) external view returns (uint256);

    function readQuoteLower(uint256 baseAmount) external view returns (uint256);

    function inBase() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol/angle-core-46e6d32837cbe97a4af0adb693e63afa0d01fc3e/contracts/interfaces/IBondingCurve.sol

// SPDX-License-Identifier: GNU GPLv3

pragma solidity ^0.8.7;


/// @title IBondingCurve
/// @author Angle Core Team
/// @notice Interface for the `BondingCurve` contract
interface IBondingCurve {
    // ============================ User Functions =================================

    function buySoldToken(
        IAgToken _agToken,
        uint256 targetSoldTokenQuantity,
        uint256 maxAmountToPayInAgToken
    ) external;

    // ========================== Governance Functions =============================

    function changeOracle(IAgToken _agToken, IOracle _oracle) external;
}
