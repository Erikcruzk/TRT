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
        require(!locked[msg.sender]); // Check if the user is already withdrawing
        locked[msg.sender] = true; // Lock the user
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(balance)) { // Send the user their balance
            revert(); // Revert the transaction if the send fails
        }
        locked[msg.sender] = false; // Unlock the user
    }
}