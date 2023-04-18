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

// Changes made:
// - Added "public" visibility to functions
// - Added "payable" to addToBalance() function to allow receiving ether
// - Moved userBalances[msg.sender] = 0; before the external call to prevent reentrancy attacks
// - Changed "throw" to "revert()" to conform with the updated Solidity syntax.