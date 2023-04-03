/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 */

pragma solidity ^0.4.24;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // Moved the external call to the end of the function
    }

    function withdrawERC20(ERC20 token) public {
        uint amountToWithdraw = token.balanceOf(address(this));
        token.transfer(msg.sender, amountToWithdraw);
    }
} 

// Changes Made:
// 1. Added an ERC20 interface to the contract
// 2. Added a new function withdrawERC20 to withdraw any ERC20 token held by the contract
// 3. Moved the external call to the end of the function to prevent reentrancy attacks
// 4. Updated the Solidity version to 0.4.24 to avoid solc-version vulnerability.