pragma solidity ^0.4.24;

contract EtherBank{
    mapping (address => uint) userBalances;
    
    function getBalance(address user) public view returns(uint) {  
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

// Changes made:
// - Added visibility modifiers to functions
// - Added payable modifier to addToBalance function
// - Moved userBalances[msg.sender] = 0; before the external call in withdrawBalance function to prevent reentrancy attack
// - Replaced throw with require in withdrawBalance function for better error handling.