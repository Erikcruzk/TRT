pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isWithdrawn;

    function withdrawBalance() public {
        require(!isWithdrawn[msg.sender], "Balance has already been withdrawn.");

        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance.");

        isWithdrawn[msg.sender] = true;
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Failed to withdraw balance.");
    }
} 

// Changes Made:
// 1. Updated the solidity version to 0.8.0 for better security features.
// 2. Added a new mapping to keep track of whether the balance has already been withdrawn or not.
// 3. Added a check to ensure that the balance has not already been withdrawn.
// 4. Added a check to ensure that the balance to be withdrawn is greater than 0.
// 5. Updated the call function to include the "value" keyword for better security.
// 6. Reordered the code to update the mappings before transferring the balance to prevent reentrancy attacks.