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

// File: ../sc_datasets/DAppSCAN/Quantstamp-MetaVault V2/metavault-3538b8a8c1ea4ec2b68a635c48b938aa1acfbc26/contracts/metavault/mock/MockPickleMasterChef.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

contract MockPickleMasterChef {
    IERC20 public pickleToken;
    IERC20 public lpToken;

    struct UserInfo {
        uint amount; // How many LP tokens the user has provided.
        uint rewardDebt; // Reward debt. See explanation below.
    }

    mapping(uint => mapping(address => UserInfo)) public userInfo;

    constructor(IERC20 _pickleToken, IERC20 _lpToken) public {
        pickleToken = _pickleToken;
        lpToken = _lpToken;
    }

    function deposit(uint _pid, uint _amount) external {
        lpToken.transferFrom(msg.sender, address(this), _amount);
        UserInfo storage user = userInfo[_pid][msg.sender];
        pickleToken.transfer(msg.sender, user.amount / 10); // always get 10% of deposited amount
        user.amount = user.amount + _amount;
    }

    function withdraw(uint _pid, uint _amount) external {
        lpToken.transfer(msg.sender, _amount);
        UserInfo storage user = userInfo[_pid][msg.sender];
        pickleToken.transfer(msg.sender, user.amount / 10); // always get 10% of deposited amount
        user.amount = user.amount - _amount;
    }

    function pendingPickle(uint, address) external view returns (uint) {
        return pickleToken.balanceOf(address(this)) / 10;
    }

    function emergencyWithdraw(uint _pid) external {
        UserInfo storage user = userInfo[_pid][msg.sender];
        lpToken.transfer(msg.sender, user.amount);
        user.amount = 0;
        user.rewardDebt = 0;
    }
}
