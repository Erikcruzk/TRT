pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) constant returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() public payable {  
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {  
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        if (!msg.sender.send(amountToWithdraw)) {
            revert();
        }
    }    
} 

// Explanation:
// The original contract had a reentrancy vulnerability, which allowed an attacker to repeatedly call the withdrawBalance function and drain the contract of its funds. 
// To fix this vulnerability, we need to ensure that the state variables are updated before sending funds to the user. 
// We can achieve this by moving the update of userBalances[msg.sender] to before the external call, and also changing the call to send instead of call.value. 
// Additionally, we need to make the functions addToBalance and withdrawBalance public and add the payable modifier to addToBalance so that it can receive funds.