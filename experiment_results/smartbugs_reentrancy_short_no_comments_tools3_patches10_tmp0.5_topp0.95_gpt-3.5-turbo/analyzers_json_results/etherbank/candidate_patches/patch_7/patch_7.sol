pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) constant public returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() public payable {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {  
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        if (!(msg.sender.call.value(amountToWithdraw)())) { 
            revert(); 
        }
    }    
} 

// Changes Made:
// 1. Made all functions public
// 2. Added payable to addToBalance function
// 3. Moved the userBalances[msg.sender] = 0; statement before the external call in withdrawBalance function to prevent reentrancy vulnerability
// 4. Replaced throw with revert in withdrawBalance function to follow best practices