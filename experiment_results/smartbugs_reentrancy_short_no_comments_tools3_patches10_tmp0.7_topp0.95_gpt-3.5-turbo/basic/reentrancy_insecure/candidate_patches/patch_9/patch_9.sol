pragma solidity ^0.8.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private lockedAccounts;

    function withdrawBalance() public {
        require(!lockedAccounts[msg.sender], "Account locked");
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        lockedAccounts[msg.sender] = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
        lockedAccounts[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Updated the compiler version
// 2. Added a new mapping to keep track of locked accounts
// 3. Added a check to prevent reentrancy attacks by locking the account during the withdrawal process
// 4. Reordered the code to update the balance and lock the account before executing the external call
// 5. Added a require statement to check if the transfer was successful.