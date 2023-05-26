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
        require(!locked[msg.sender]); // prevents reentrancy

        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);

        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;

        msg.sender.transfer(amountToWithdraw);

        locked[msg.sender] = false;
    }
}