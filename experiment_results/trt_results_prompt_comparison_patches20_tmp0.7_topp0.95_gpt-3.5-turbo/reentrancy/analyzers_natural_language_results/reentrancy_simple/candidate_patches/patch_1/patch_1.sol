pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) locked;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!locked[msg.sender]); // Check if the user is not already in the process of withdrawing
        locked[msg.sender] = true; // Set the user as locked
        uint balance = userBalance[msg.sender]; // Store the balance in a local variable
        userBalance[msg.sender] = 0; // Set the user's balance to zero
        if (!msg.sender.call.value(balance)()) { // Send the balance to the user
            revert(); // Revert if the call fails
        }
        locked[msg.sender] = false; // Set the user as unlocked
    }
}