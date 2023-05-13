pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool locked;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!locked); // check if the contract is locked
        locked = true; // lock the contract before calling external contract
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(balance);
        locked = false; // unlock the contract after external contract call
    }
}