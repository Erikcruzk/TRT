pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;
    bool locked = false;

    function getBalance(address user) constant returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {  
        require(!locked);
        locked = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked = false;
    }    
}