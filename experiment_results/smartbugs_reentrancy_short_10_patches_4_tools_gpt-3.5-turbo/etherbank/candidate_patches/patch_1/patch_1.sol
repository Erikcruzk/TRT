/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author:
 * @fixed_at_lines: 18, 21
 */

pragma solidity ^0.4.24;

contract EtherBank {
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
// 1. Added visibility modifiers to functions
// 2. Removed unnecessary throw statement
// 3. Moved the state change before the external call to prevent reentrancy vulnerability.