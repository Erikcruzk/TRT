/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author: -
 * @fixed_at_lines: 13-22
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
        if (!(msg.sender.call.value(amountToWithdraw)())) {
            revert();
        }
    }    
} 

// Changes Made:
// 1. Added visibility modifiers to all functions.
// 2. Added payable modifier to addToBalance function.
// 3. Reordered the statements in withdrawBalance function to prevent reentrancy.
// 4. Replaced throw with revert in withdrawBalance function.