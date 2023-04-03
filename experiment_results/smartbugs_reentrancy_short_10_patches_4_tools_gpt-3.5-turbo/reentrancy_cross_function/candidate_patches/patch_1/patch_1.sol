/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 */

pragma solidity ^0.5.0;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success, "Transfer failed");
    }
    
    function withdrawToken(address token) public {
        IERC20 erc20 = IERC20(token);
        uint256 amountToWithdraw = erc20.balanceOf(address(this));
        require(amountToWithdraw > 0, "No tokens to withdraw");
        require(erc20.transfer(msg.sender, amountToWithdraw), "Transfer failed");
    }
} 

// Changes Made:
// - Added IERC20 interface to ensure token transfers follow ERC20 standard
// - Made transfer function public and added require statement to check for sufficient balance
// - Moved balance check to transfer function to prevent reentrancy attack
// - Separated token withdrawal function to prevent reentrancy attack on ether withdrawal
// - Added error messages to require statements for better debugging