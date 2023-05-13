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
        require(!locked[msg.sender]); // Prevent reentrancy
        locked[msg.sender] = true; // Lock the user
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; // Update the balance before sending
        if (!msg.sender.send(balance)) { // Send the balance
            userBalance[msg.sender] = balance; // Rollback on failure
        }
        locked[msg.sender] = false; // Unlock the user
    }
}