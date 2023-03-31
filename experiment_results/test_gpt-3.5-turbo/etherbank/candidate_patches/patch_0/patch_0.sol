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
        if (!(msg.sender.call.value(amountToWithdraw)())) { 
            revert();
        }
        locked[msg.sender] = false;
    }    
} 

// Changes made:
// 1. Made functions public
// 2. Added a mapping to keep track of locked accounts
// 3. Added a require statement to check if balance is greater than zero
// 4. Added a require statement to check if account is not already locked
// 5. Locked the account before sending ether to prevent reentrancy attacks
// 6. Unlocked the account after ether transfer is complete