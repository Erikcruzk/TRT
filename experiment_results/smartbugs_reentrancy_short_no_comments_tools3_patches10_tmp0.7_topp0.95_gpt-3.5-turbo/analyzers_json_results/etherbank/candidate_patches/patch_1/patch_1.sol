pragma solidity ^0.4.24;

contract EtherBank {
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
        msg.sender.transfer(amountToWithdraw);
    }    
} 

// Changes made:
// 1. Made all functions public
// 2. Added "payable" modifier to addToBalance function to allow for receiving ether
// 3. Removed the external call in withdrawBalance and instead used the transfer function to send ether to the user's address before updating their balance to zero. This prevents reentrancy attacks.