pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) constant returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() payable {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {  
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }    
} 

// Changes Made:
// 1. Added payable to addToBalance function to accept ether
// 2. Reordered the code in withdrawBalance function to prevent reentrancy attack
// 3. Replaced throw with require in withdrawBalance function for better error handling.