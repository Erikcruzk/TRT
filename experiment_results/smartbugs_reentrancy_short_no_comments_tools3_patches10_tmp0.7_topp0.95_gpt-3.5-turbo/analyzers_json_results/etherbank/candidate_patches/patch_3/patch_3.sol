pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) public constant returns(uint) {  
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
// 1. Made all functions public for accessibility.
// 2. Added "payable" keyword to "addToBalance" function to accept ether.
// 3. Moved the line "userBalances[msg.sender] = 0;" before the external call to prevent reentrancy vulnerability.
// 4. Replaced "throw" with "revert()" for better error handling.