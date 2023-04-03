/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @fixed_at_lines: 24
 */

pragma solidity ^0.4.24;

contract Reentrancy_cross_function {

    // FIXED
    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update the user balance before sending the funds
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to 0.4.24
// 2. Moved the mapping update before the external call to prevent reentrancy attacks
// 3. Removed author information since it is not relevant to the code