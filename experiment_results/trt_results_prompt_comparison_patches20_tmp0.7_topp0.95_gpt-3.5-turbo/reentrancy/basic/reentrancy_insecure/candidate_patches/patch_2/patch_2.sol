pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private userWithdrawals;

    function withdrawBalance() public {
        require(!userWithdrawals[msg.sender], "Withdrawal already in progress");
        
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        userWithdrawals[msg.sender] = true;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");

        userBalances[msg.sender] = 0;
        userWithdrawals[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a mapping to keep track of users who have initiated a withdrawal to prevent reentrancy attacks.
// 2. Added a check to ensure that the user has a non-zero balance before initiating the withdrawal.
// 3. Added a boolean flag to prevent concurrent withdrawals by the same user.
// 4. Updated the transfer function to use the new syntax for Solidity 0.8.0.
// 5. Reordered the code to prevent a possible reentrancy attack by setting the userWithdrawals flag before transferring the funds.