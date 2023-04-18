pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) constant returns(uint) {  
        return userBalances[user];
    }

    function addToBalance() payable {  
        require(msg.value > 0);
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() {  
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }    
} 

// Changes Made:
// - Added 'payable' to addToBalance function to allow it to receive ether
// - Added 'require' statement to check if msg.value is greater than 0 in addToBalance function
// - Added 'require' statement to check if amountToWithdraw is greater than 0 in withdrawBalance function
// - Changed the order of statements in withdrawBalance function to prevent reentrancy vulnerability
// - Replaced external call with transfer in withdrawBalance function to prevent reentrancy vulnerability