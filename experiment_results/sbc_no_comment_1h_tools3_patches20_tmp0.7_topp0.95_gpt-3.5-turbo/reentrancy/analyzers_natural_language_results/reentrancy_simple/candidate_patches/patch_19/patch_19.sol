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
        require(!locked[msg.sender]); //check if locked
        locked[msg.sender] = true; //lock the sender
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if(msg.sender.call.value(balance)()) {
            locked[msg.sender] = false; //unlock the sender
        } else {
            userBalance[msg.sender] = balance;
            locked[msg.sender] = false; //unlock the sender
            revert(); //revert the state changes
        }
    }
}