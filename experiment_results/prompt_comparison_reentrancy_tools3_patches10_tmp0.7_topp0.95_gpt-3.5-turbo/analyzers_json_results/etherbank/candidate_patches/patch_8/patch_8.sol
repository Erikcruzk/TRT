pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) locked;

    function getBalance(address user) constant returns (uint) {
        return userBalances[user];
    }

    function addToBalance() payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!locked[msg.sender]); // check if user is not locked
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true; // lock user

        if (!(msg.sender.call.value(amountToWithdraw)())) {
            throw;
        }

        locked[msg.sender] = false; // unlock user
    }
}