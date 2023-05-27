pragma solidity ^0.8.0;

contract Reentrancy_fixed {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "The contract is locked");
        locked = true;
        
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        userBalances[msg.sender] = 0;
        locked = false;
        
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
    }

    function depositBalance() public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        userBalances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// Changes made:
// 1. Added a boolean variable "locked" to prevent reentrancy attacks.
// 2. Added a check to ensure that the user has sufficient balance to withdraw.
// 3. Moved the withdrawal of balance to the end of the function to prevent reentrancy attacks.
// 4. Added a deposit function to allow users to add balance to their account.
// 5. Added a get balance function to allow users to view their balance.