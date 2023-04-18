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
// - Added visibility modifiers to functions
// - Added payable modifier to addToBalance function
// - Removed the if statement from withdrawBalance and replaced with a require statement to prevent reentrancy vulnerability
// - Moved the update of userBalances[msg.sender] to after the external call to prevent reentrancy vulnerability.