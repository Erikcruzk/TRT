pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) reentrancyLock;

    function getBalance(address user) constant returns (uint) {
        return userBalances[user];
    }

    function addToBalance() {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        uint amountToWithdraw = userBalances[msg.sender];

        require(amountToWithdraw > 0);
        require(!reentrancyLock[msg.sender]);
        reentrancyLock[msg.sender] = true;

        if (!(msg.sender.call.value(amountToWithdraw)())) {
            throw;
        }

        userBalances[msg.sender] = 0;
        reentrancyLock[msg.sender] = false;
    }
}