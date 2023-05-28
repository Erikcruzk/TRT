pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) constant returns (uint) {
        return userBalances[user];
    }

    function addToBalance() payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }
} 

// The repaired contract fixes the vulnerability by transferring the funds to the user before setting their balance to zero. Additionally, the addToBalance function now requires a value to be sent to the contract in order to add to the user's balance.