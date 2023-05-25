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
        require(!locked[msg.sender]); //check if the user is not already withdrawing
        locked[msg.sender] = true; //set the user as currently withdrawing
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; //set the user balance to 0 before sending
        msg.sender.transfer(balance); //send the balance to the user
        locked[msg.sender] = false; //set the user as not withdrawing anymore
    }
}