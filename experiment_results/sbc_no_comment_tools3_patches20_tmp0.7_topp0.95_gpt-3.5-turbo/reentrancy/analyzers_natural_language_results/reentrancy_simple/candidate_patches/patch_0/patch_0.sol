pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) userLock;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!userLock[msg.sender]); // prevent reentrancy
        userLock[msg.sender] = true; // lock user to prevent reentrancy
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!(msg.sender.call.value(balance)())) {
            throw;
        }
        userLock[msg.sender] = false; // unlock user after call
    }
}