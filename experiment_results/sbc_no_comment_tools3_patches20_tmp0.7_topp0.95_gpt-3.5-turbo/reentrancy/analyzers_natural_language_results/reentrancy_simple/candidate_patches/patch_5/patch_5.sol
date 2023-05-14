pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) isCurrentlyWithdrawing;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!isCurrentlyWithdrawing[msg.sender]); // Check if the user is currently withdrawing
        isCurrentlyWithdrawing[msg.sender] = true; // Set the user as currently withdrawing
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0; // Set the user balance to 0 before sending the funds
        if (!(msg.sender.call.value(balanceToWithdraw)())) {
            revert(); // Revert the transaction if the external call fails
        }
        isCurrentlyWithdrawing[msg.sender] = false; // Set the user as not currently withdrawing
    }
}