/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 * @fixed_by: team-xyz
 */

pragma solidity ^0.4.24;

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount); // check if sender has enough balance
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // set sender's balance to 0 before transferring funds
        require(msg.sender.call.value(amountToWithdraw)()); // transfer funds after setting balance to 0
    }
} 

// Changes Made:
// 1. Added a require statement to check if the sender has enough balance before transferring funds.
// 2. Set the sender's balance to 0 before transferring funds to prevent reentrancy attacks.
// 3. Changed the function visibility of transfer() to public to allow external calls.