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
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        if (!(msg.sender.call.value(amountToWithdraw)())) {
            revert();
        }
        locked[msg.sender] = false;
    }
}