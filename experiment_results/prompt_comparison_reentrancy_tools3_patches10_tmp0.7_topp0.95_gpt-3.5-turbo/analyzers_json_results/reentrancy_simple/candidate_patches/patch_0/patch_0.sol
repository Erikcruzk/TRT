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
        require(!locked[msg.sender]); // added require to prevent reentrancy
        locked[msg.sender] = true; // added lock
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(balance)) { // using send instead of call to prevent reentrancy
            revert();
        }
        locked[msg.sender] = false; // release lock
    }
}