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
        require(!locked[msg.sender]); //check if the user is already in the withdraw process
        locked[msg.sender] = true; //lock the user to avoid multiple withdrawals

        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; //set the balance to 0 before the external call
        msg.sender.transfer(balance); //transfer the balance to the user

        locked[msg.sender] = false; //unlock the user after the transfer
    }
}