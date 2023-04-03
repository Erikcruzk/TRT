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
        require(msg.sender.call.value(amountToWithdraw)());
    }    
} 

// Changes made:
// - Added "public" visibility modifier to functions for better readability
// - Added "payable" modifier to "addToBalance" function to allow it to receive ether
// - Reordered code in "withdrawBalance" function to prevent reentrancy vulnerability
// - Replaced "throw" with "require" to revert transaction on failure instead of throwing an exception