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

// File: ../sc_datasets/DAppSCAN/SlowMist-Booster-Protocol_智能安全审计报告/boosterProtocol-946b15629c410d706856584f3aa04001d6a55bd2/contracts/interfaces/ISafeBox.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

interface ISafeBox {

    function bank() external view returns(address);

    function token() external view returns(address);

    function getSource() external view returns (string memory);

    function supplyRatePerBlock() external view returns (uint256);
    function borrowRatePerBlock() external view returns (uint256);

    function getBorrowInfo(uint256 _bid) external view 
            returns (address owner, uint256 amount, address strategy, uint256 pid);
    function getBorrowId(address _strategy, uint256 _pid, address _account) external view returns (uint256 borrowId);
    function getBorrowId(address _strategy, uint256 _pid, address _account, bool _add) external returns (uint256 borrowId);
    function getDepositTotal() external view returns (uint256);
    function getBorrowTotal() external view returns (uint256);
    function getBorrowAmount(address _account) external view returns (uint256 value); 
    function getBaseTokenPerLPToken() external view returns (uint256);

    function deposit(uint256 _value) external;
    function withdraw(uint256 _value) external;
    
    function emergencyWithdraw() external;
    function emergencyRepay(uint256 _bid, uint256 _value) external;

    function borrowInfoLength() external view returns (uint256);

    function borrow(uint256 _bid, uint256 _value, address _to) external;
    function repay(uint256 _bid, uint256 _value) external;
    function claim(uint256 _tTokenAmount) external;

    function update() external;
    function mintDonate(uint256 _value) external;

    function pendingSupplyAmount(address _account) external view returns (uint256 value);   
    function pendingBorrowAmount(uint256 _bid) external view returns (uint256 value);
    function pendingBorrowRewards(uint256 _bid) external view returns (uint256 value);
}
