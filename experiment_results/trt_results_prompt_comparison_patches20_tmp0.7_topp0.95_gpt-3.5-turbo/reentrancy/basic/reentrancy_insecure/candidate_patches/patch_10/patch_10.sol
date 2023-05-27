pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdrawal already in progress");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");

        locked[msg.sender] = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Updated compiler version to ^0.8.0
// 2. Added a mapping to track if withdrawal is already in progress for a user
// 3. Added a require statement to check if user has balance to withdraw
// 4. Added a lock mechanism to prevent reentrancy attacks
// 5. Changed the call function to use the new syntax (with curly braces) and added a require statement to check if withdrawal was successful.