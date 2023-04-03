/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
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
// - Added visibility modifiers to functions
// - Removed unnecessary throw statement
// - Moved state changes before external call in withdrawBalance function
// - Added require statement to check for successful external call in withdrawBalance function