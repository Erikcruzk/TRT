/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @fixed_at_lines: 13-20
 */

pragma solidity ^0.4.0;

contract Reentrancy_fixed {

    // FIXED
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is not already in a withdraw process
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true; // set the lock
        require(msg.sender.call.value(amountToWithdraw)("")); // perform the external call
        locked[msg.sender] = false; // release the lock
    }
} 

// Explanation:
// The repaired contract adds a "locked" mapping to keep track of whether a user is already in a withdraw process or not.
// Before executing the withdraw, it checks if the user is not already in a withdraw process by checking the "locked" mapping.
// If the user is not locked, it proceeds with the withdraw, sets the lock, and performs the external call.
// After the call, it releases the lock. This prevents reentrancy attacks because the function can only be called once for each user at a time.