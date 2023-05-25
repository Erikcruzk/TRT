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
        require(!locked[msg.sender]); // Check if sender is not already locked
        locked[msg.sender] = true; // Lock the sender to prevent reentrancy
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; // Update the state before external call
        if (!msg.sender.call.value(balance)()) {
            revert(); // Revert if external call fails
        }
        locked[msg.sender] = false; // Unlock the sender after external call
    }
}