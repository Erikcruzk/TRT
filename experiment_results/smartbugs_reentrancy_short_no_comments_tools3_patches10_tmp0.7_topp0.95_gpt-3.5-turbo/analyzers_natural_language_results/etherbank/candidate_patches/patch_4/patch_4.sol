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
		msg.sender.transfer(amountToWithdraw);
	}    
} 

// Fixed the vulnerability of reentrancy by transferring the funds to the user's account before resetting their balance. Also made functions public and added payable modifier to addToBalance function.