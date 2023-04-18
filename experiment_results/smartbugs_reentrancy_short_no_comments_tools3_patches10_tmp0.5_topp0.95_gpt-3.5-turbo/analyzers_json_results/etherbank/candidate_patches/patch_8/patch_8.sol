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
        require(msg.sender.call.value(amountToWithdraw)());
    }    
} 

// Changes Made:
// 1. Made the getBalance() function public
// 2. Made the addToBalance() function payable
// 3. Moved the userBalances[msg.sender] = 0; statement before the external call to prevent reentrancy vulnerability
// 4. Used require() instead of if() and throw; to handle errors and prevent reentrancy vulnerability.