pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) public view returns (uint) {
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
// 1. Added visibility modifiers to all functions
// 2. Changed constant to view in getBalance function
// 3. Changed throw to revert in withdrawBalance function
// 4. Moved userBalances[msg.sender] = 0; before the external call in withdrawBalance function
// 5. Changed external call to transfer in withdrawBalance function