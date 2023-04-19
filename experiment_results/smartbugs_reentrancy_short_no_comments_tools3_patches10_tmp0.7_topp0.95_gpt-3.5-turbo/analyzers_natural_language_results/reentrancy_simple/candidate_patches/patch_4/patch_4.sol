pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;

    function getBalance(address u) constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() payable{
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (balance > 0 && msg.sender.call.value(balance)()) {
            // Success
        } else {
            userBalance[msg.sender] = balance;
            revert();
        }
    }
}