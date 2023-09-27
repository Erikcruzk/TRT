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

// File: ../sc_datasets/DAppSCAN/Hacken-Tenderize/tender-core-5b3b625d09e0bc02529946d9f2128af0c08c1a31/contracts/test/MockStaking.sol

// SPDX-FileCopyrightText: 2021 Tenderize <info@tenderize.me>

// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract MockStaking {
    IERC20 token;

    uint256 public staked;
    uint256 secondaryRewards;

    struct UnstakeLock {
        uint256 amount;
        address account;
    }

    mapping(uint256 => UnstakeLock) public unstakeLocks;
    uint256 public nextUnstakeLockID;

    mapping(bytes4 => bool) reverts;

    modifier reverted(bytes4 _sel) {
        require(!reverts[_sel]);
        _;
    }

    constructor(IERC20 _token) {
        token = _token;
    }

    function setStaked(uint256 _staked) public {
        staked = _staked;
    }

    function setSecondaryRewards(uint256 _secondaryRewards) public {
        secondaryRewards = _secondaryRewards;
    }

    function setReverts(bytes4 _sel, bool yn) public {
        reverts[_sel] = yn;
    }

    function changePendingUndelegation(uint256 _unstakeLockID, uint256 _newAmount) external {
        unstakeLocks[_unstakeLockID].amount = _newAmount;
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Tenderize/tender-core-5b3b625d09e0bc02529946d9f2128af0c08c1a31/contracts/test/LivepeerMock.sol

// SPDX-FileCopyrightText: 2021 Tenderize <info@tenderize.me>

// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;


contract LivepeerMock is MockStaking {
    constructor(IERC20 _token) MockStaking(_token) {}

    function bond(uint256 _amount, address _to) external reverted(this.bond.selector) {
        require(token.transferFrom(msg.sender, address(this), _amount));
        staked += _amount;
    }

    function unbond(uint256 _amount) external reverted(this.unbond.selector) {
        staked -= _amount;
        unstakeLocks[nextUnstakeLockID] = UnstakeLock({ amount: _amount, account: msg.sender });
        nextUnstakeLockID++;
    }

    function rebondFromUnbonded(address _to, uint256 _unbondingLockId) external {
        return;
    }

    function withdrawStake(uint256 _unbondingLockId) external reverted(this.withdrawStake.selector) {
        token.transfer(unstakeLocks[_unbondingLockId].account, unstakeLocks[_unbondingLockId].amount);
    }

    function withdrawFees() external reverted(this.withdrawFees.selector) {
        staked += secondaryRewards;
        secondaryRewards = 0;
    }

    function pendingFees(address _delegator, uint256 _endRound) external view returns (uint256) {
        return secondaryRewards;
    }

    function pendingStake(address _delegator, uint256 _endRound) external view returns (uint256) {
        return staked;
    }
}