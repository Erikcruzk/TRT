/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author:
 * @vulnerable_at_lines: 21
 */

pragma solidity ^0.4.24;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) public view returns(uint) {  
		return userBalances[user];
	}

	function addToBalance() public payable {  
		require(msg.value > 0);
		userBalances[msg.sender] += msg.value;
	}

	function withdrawBalance() public {  
		uint amountToWithdraw = userBalances[msg.sender];
		userBalances[msg.sender] = 0;
		require(msg.sender.call.value(amountToWithdraw)());
	}    
} 

// Changes Made:
// - Added "public" visibility to all functions
// - Added "payable" modifier to addToBalance() function
// - Added "require" statement to check if msg.value is greater than 0 before adding to balance
// - Moved the call to external contract to the end of the function to prevent reentrancy attack
// - Updated pragma version to ^0.4.24 to use the latest compiler version and fix deprecated warnings.