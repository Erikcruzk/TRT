/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author:
 * @fixed_by: John Doe
 * @vulnerable_at_lines: 21
 */

pragma solidity ^0.4.24;

contract EtherBank{
    mapping (address => uint) userBalances;
    mapping (address => bool) userLocks;

    function getBalance(address user) public view returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() public payable {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {  
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        require(!userLocks[msg.sender]);
        userLocks[msg.sender] = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        userLocks[msg.sender] = false;
    }    
}

// Changes Made:
// - Added a userLocks mapping to prevent reentrancy
// - Changed getBalance and addToBalance to be view and payable functions respectively
// - Added a require statement to check if the user has balance to withdraw
// - Changed the external call to transfer() instead of call.value() to prevent reentrancy