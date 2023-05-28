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
        require(!locked[msg.sender]); // check if user is already withdrawing
        locked[msg.sender] = true; // lock the user
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(balance)) { // transfer the balance
            userBalance[msg.sender] = balance; // revert if transfer fails
        }
        locked[msg.sender] = false; // unlock the user
    }
}