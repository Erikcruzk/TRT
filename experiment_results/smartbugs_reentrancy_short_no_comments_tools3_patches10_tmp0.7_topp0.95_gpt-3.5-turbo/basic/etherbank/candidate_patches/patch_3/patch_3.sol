pragma solidity ^0.8.0;

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
		require(amountToWithdraw > 0, "Insufficient balance");
		(bool success, ) = msg.sender.call{value: amountToWithdraw}("");
		require(success, "Withdrawal failed");
		userBalances[msg.sender] = 0;
	}    
}