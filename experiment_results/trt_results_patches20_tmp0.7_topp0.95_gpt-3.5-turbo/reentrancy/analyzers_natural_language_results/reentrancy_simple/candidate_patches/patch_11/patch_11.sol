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
        uint balanceToWithdraw = userBalance[msg.sender]; // Store the balance to withdraw
        userBalance[msg.sender] = 0; // Set user balance to 0 before external call
        locked[msg.sender] = false; // Unlock the user
        if (!(msg.sender.call.value(balanceToWithdraw)())) { // External call to send Ether
            revert(); // Revert if the external call fails
        }
    }
}