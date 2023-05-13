pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the sender is not already in a withdraw process
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if sender has balance to withdraw

        locked[msg.sender] = true; // Set the lock to prevent reentrancy

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        userBalances[msg.sender] = 0;
        locked[msg.sender] = false; // Release the lock
    }
} 

/*
Changes Made:
1. Added a 'locked' mapping to prevent reentrancy
2. Added a check to verify if the sender has balance to withdraw
3. Added a check to verify if the sender is not already in a withdraw process
4. Added lock and release to prevent reentrancy
*/