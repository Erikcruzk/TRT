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
        require(!locked[msg.sender]); // Check if the user's account is already locked
        locked[msg.sender] = true; // Lock the user's account
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(balance)) { // Send the balance to the user
            userBalance[msg.sender] = balance; // If sending fails, revert the transaction and restore the user's balance
            locked[msg.sender] = false; // Unlock the user's account
            revert();
        }
        locked[msg.sender] = false; // Unlock the user's account
    }
}