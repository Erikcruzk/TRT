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
        require(!locked[msg.sender]); // Prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // User must have funds to withdraw
        locked[msg.sender] = true; // Set lock to prevent reentrancy
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false; // Release lock
    }
}