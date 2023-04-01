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
            locked[msg.sender] = false;
            userBalances[msg.sender] = amountToWithdraw;
            revert();
        }
        locked[msg.sender] = false;
    }    
} 

// Changes Made:
// 1. Added a mapping to keep track of locked accounts during withdrawal
// 2. Reordered the code to first lock the account, then update balance and finally unlock the account
// 3. Changed the call function to send, which is a safer way of transferring ether
// 4. Added a require statement to check if the account is not already locked before withdrawing