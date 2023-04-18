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

// Changes Made:
// 1. Added visibility modifiers to all functions.
// 2. Replaced "constant" with "view" in the getBalance function.
// 3. Added "payable" modifier to the addToBalance function to allow it to receive ether.
// 4. Moved the userBalances[msg.sender] = 0; line before the external call in withdrawBalance function to prevent reentrancy attack.
// 5. Replaced "throw" with "require" in the withdrawBalance function to handle errors in a more secure way.