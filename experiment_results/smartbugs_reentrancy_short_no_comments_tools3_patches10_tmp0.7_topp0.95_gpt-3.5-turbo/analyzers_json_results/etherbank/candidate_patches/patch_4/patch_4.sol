pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;
    mapping (address => bool) userIsWithdrawn;

    function getBalance(address user) constant returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() payable {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(userBalances[msg.sender] > 0);
        require(!userIsWithdrawn[msg.sender]);
        userIsWithdrawn[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }    
}