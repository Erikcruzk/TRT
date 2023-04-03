/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author:
 * @fixed_at_lines: 21
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
        require(msg.sender.call.value(amountToWithdraw)(), "Failed to transfer funds");
    }    
} 

// Changes Made:
// 1. Added visibility to functions
// 2. Added payable modifier to addToBalance function
// 3. Moved userBalances[msg.sender] = 0; statement before the external call to prevent reentrancy attack
// 4. Replaced throw with require statement with error message to handle external call failure