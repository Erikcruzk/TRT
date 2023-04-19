pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) constant returns(uint) {  
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
// 1. Added "public" visibility to functions
// 2. Added "payable" to the "addToBalance" function to allow it to receive ether
// 3. Moved the line to reset the user balance to 0 before the external call to prevent reentrancy vulnerability
// 4. Replaced "throw" with "revert()" for better error handling