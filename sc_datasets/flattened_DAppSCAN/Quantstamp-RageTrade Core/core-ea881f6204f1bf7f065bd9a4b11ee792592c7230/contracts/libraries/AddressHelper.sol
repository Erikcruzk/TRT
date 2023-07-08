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

// File: ../sc_datasets/DAppSCAN/Quantstamp-RageTrade Core/core-ea881f6204f1bf7f065bd9a4b11ee792592c7230/contracts/interfaces/IVToken.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IVToken is IERC20 {
    function mint(address account, uint256 amount) external;

    function burn(uint256 amount) external;

    function setVPoolWrapper(address) external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-RageTrade Core/core-ea881f6204f1bf7f065bd9a4b11ee792592c7230/contracts/libraries/AddressHelper.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

/// @title Address helper functions
library AddressHelper {
    /// @notice Convert address to uint32, using the least significant 32 bits
    /// @param addr Address to convert
    /// @return truncated last 4 bytes of the address
    function truncate(address addr) internal pure returns (uint32 truncated) {
        assembly {
            truncated := and(addr, 0xffffffff)
        }
    }

    function truncate(IERC20 addr) internal pure returns (uint32 truncated) {
        return truncate(address(addr));
    }

    function eq(address a, address b) internal pure returns (bool) {
        return a == b;
    }

    function eq(IERC20 a, IERC20 b) internal pure returns (bool) {
        return eq(address(a), address(b));
    }

    function isZero(address a) internal pure returns (bool) {
        return a == address(0);
    }

    function isZero(IERC20 a) internal pure returns (bool) {
        return isZero(address(a));
    }
}
