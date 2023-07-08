// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldProtocol/fyDai-4422fda75931f2bfea49f5041ec90dc026e5c03d/contracts/interfaces/IFlashMinter.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.6.10;


interface IFlashMinter {
    function executeOnFlashMint(address to, uint256 yDaiAmount, bytes calldata data) external;
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

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldProtocol/fyDai-4422fda75931f2bfea49f5041ec90dc026e5c03d/contracts/interfaces/IYDai.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.6.10;

interface IYDai is IERC20 {
    function isMature() external view returns(bool);
    function maturity() external view returns(uint);
    function chi0() external view returns(uint);
    function rate0() external view returns(uint);
    function chiGrowth() external view returns(uint);
    function rateGrowth() external view returns(uint);
    function mature() external;
    function mint(address, uint) external;
    function burn(address, uint) external;
    function flashMint(address, uint, bytes calldata) external;
    // function transfer(address, uint) external returns (bool);
    // function transferFrom(address, address, uint) external returns (bool);
    // function approve(address, uint) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldProtocol/fyDai-4422fda75931f2bfea49f5041ec90dc026e5c03d/contracts/mocks/FlashMinterMock.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.6.10;


contract FlashMinterMock is IFlashMinter {

    event Parameters(address user, uint256 amount, bytes data);

    uint256 public flashBalance;

    function executeOnFlashMint(address to, uint256 yDaiAmount, bytes calldata data) external override {
        flashBalance = IYDai(msg.sender).balanceOf(address(this));
        emit Parameters(to, yDaiAmount, data);
    }

    function flashMint(address yDai, uint256 amount, bytes calldata data) public {
        IYDai(yDai).flashMint(address(this), amount, data);
    }
}
