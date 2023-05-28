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
        require(!locked[msg.sender]); // check if the account is not locked
        locked[msg.sender] = true; // set lock on the account
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; // set balance to zero before sending
        msg.sender.transfer(balance); // send the balance to the account
        locked[msg.sender] = false; // unlock the account
    }
}