pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) isLocked;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!isLocked[msg.sender]); // Check if user is not locked
        isLocked[msg.sender] = true; // Lock user
        uint balance = userBalance[msg.sender]; // Store user balance in a local variable
        userBalance[msg.sender] = 0; // Set user balance to 0 before transfer
        msg.sender.transfer(balance); // Transfer user balance
        isLocked[msg.sender] = false; // Unlock user
    }
}