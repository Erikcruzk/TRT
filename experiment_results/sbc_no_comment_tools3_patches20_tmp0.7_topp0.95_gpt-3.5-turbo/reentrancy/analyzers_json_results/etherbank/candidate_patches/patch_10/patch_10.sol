pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) constant returns (uint) {
        return userBalances[user];
    }

    function addToBalance() payable {
        require(msg.value > 0);
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }
}