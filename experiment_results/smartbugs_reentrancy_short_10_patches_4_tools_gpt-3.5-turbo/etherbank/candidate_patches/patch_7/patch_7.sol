/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author:
 * @fixed_by: [Your Name]
 * @vulnerable_at_lines: 21
 */

pragma solidity ^0.4.24;

contract EtherBank{
    mapping (address => uint) userBalances;
    mapping (address => bool) locked;

    function getBalance(address user) public view returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() public payable {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {  
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }    
}

// Changes Made:
// 1. Added a boolean mapping 'locked' to prevent reentrancy attack.
// 2. Made all functions public for better accessibility.
// 3. Added a require statement to check if the balance is greater than zero before withdrawing.
// 4. Replaced 'call.value' with 'transfer' to prevent reentrancy attack.