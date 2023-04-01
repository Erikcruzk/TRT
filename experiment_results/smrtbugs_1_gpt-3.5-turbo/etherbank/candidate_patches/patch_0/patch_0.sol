/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author: -
 * @fixed_at_lines: 21
 */

pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;
    mapping (address => bool) locked;

    function getBalance(address user) constant returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {  
        uint amountToWithdraw = userBalances[msg.sender];
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        if (!msg.sender.send(amountToWithdraw)) {
            throw;
        }
        locked[msg.sender] = false;
    }    
} 

// Changes Made:
// 1. Added a 'locked' mapping to prevent reentrancy attack
// 2. Reordered the sequence of operations to follow the checks-effects-interactions pattern
// 3. Changed the call function to send to prevent reentrancy attack