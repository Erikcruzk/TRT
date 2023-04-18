pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) public constant returns(uint) {  
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
// 1. Made all functions public for accessibility.
// 2. Added payable to addToBalance function to allow for receiving ether.
// 3. Reordered statements in withdrawBalance function to prevent reentrancy vulnerability.
// 4. Changed throw statement to require statement for better error handling.