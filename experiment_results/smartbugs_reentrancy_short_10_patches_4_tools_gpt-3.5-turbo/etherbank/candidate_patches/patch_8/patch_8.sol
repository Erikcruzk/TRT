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
		userBalances[msg.sender] += msg.value;
	}

	function withdrawBalance() public {  
		uint amountToWithdraw = userBalances[msg.sender];
		userBalances[msg.sender] = 0;
        // <yes> <report> REENTRANCY
		require(msg.sender.call.value(amountToWithdraw)());
	}    
} 

// Changes made:
// 1. Added visibility modifiers to all functions
// 2. Added payable modifier to addToBalance function
// 3. Moved balance update before the external call in withdrawBalance function
// 4. Replaced throw with require for better error handling