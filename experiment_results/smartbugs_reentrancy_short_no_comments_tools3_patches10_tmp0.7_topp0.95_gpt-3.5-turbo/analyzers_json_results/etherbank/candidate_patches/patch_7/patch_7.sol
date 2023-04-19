pragma solidity ^0.4.0;

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
// 1. Made the getBalance function a view function.
// 2. Added the payable modifier to the addToBalance function.
// 3. Moved the assignment of userBalances[msg.sender] to 0 before the external call in the withdrawBalance function.
// 4. Used the require statement to ensure the external call is successful.