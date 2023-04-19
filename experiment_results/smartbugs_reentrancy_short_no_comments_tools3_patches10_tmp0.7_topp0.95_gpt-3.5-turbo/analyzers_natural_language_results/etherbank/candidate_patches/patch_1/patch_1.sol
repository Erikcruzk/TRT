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
        msg.sender.transfer(amountToWithdraw);
    }    
}

// Changes Made:
// 1. Added "public" and "view" to getBalance function.
// 2. Added "payable" to addToBalance function.
// 3. Moved the userBalances[msg.sender] = 0; line before the external call in withdrawBalance function.
// 4. Replaced the external call with the transfer function in withdrawBalance function.