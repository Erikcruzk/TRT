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
        require(!locked[msg.sender]); // Check if the sender is already in a withdraw process
        locked[msg.sender] = true; // Lock the sender to prevent reentrancy

        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; // Update the balance before transferring the funds
        msg.sender.transfer(balance); // Send the funds to the sender

        locked[msg.sender] = false; // Unlock the sender
    }
}