/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author:
 * @vulnerable_at_lines: 24
 */

pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Reentrancy_cross_function {
    mapping (address => uint) private userBalances;
    IERC20 private token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function transfer(address to, uint amount) public {
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
        userBalances[to] += amount;
        token.transfer(to, amount);
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
    }
} 

// Changes Made:
// - Added IERC20 interface for token transfer
// - Added constructor to initialize the token
// - Modified transfer function to use IERC20 interface and added require statement to check balance
// - Reordered the statements in withdrawBalance function to prevent reentrancy attack and added error handling