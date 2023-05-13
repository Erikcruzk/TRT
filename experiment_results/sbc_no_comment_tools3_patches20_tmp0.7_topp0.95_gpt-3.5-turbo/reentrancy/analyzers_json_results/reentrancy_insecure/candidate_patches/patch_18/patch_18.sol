pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if locked
        locked[msg.sender] = true; // Set locked to true
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update state before external call
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false; // Set locked to false
    }
} 

// Changes made:
// 1. Added a locked mapping to prevent reentrancy
// 2. Moved the state update before the external call to prevent reentrancy attacks.