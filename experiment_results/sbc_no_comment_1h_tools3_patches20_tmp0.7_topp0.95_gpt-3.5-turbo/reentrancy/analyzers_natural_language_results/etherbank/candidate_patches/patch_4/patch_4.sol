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
        require(!locked[msg.sender]); // prevent reentrancy
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // ensure user has balance to withdraw
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
        msg.sender.transfer(amountToWithdraw);
    }
}