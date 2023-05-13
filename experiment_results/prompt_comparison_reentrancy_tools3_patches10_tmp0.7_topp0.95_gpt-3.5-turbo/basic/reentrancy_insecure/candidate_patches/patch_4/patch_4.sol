pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isWithdrawn;

    function withdrawBalance() public {
        require(!isWithdrawn[msg.sender], "Withdrawal already processed.");
        
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance.");

        isWithdrawn[msg.sender] = true;
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
    }
} 

// Changes made:
// 1. Updated pragma version to ^0.8.0 to use the latest Solidity version.
// 2. Added a mapping to keep track of whether a user has already withdrawn their balance to prevent reentrancy attacks.
// 3. Added a check to ensure that the user has a non-zero balance before withdrawing.
// 4. Moved the state updates (isWithdrawn and userBalances) before the external call to prevent reentrancy attacks from manipulating the state after the call.
// 5. Replaced the old .call() function with the new syntax that explicitly specifies the value being transferred. Also added an error message for failed transfers.