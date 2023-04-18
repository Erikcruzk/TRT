pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdraw already in progress");
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
    }
} 

// Changes made:
// 1. Updated the Solidity version to 0.8.0
// 2. Added a new mapping to keep track of whether a withdraw is already in progress for a user
// 3. Added a check to ensure that a withdraw is not already in progress for a user
// 4. Reordered the code to first update the balance and release the lock before transferring the funds to prevent reentrancy attacks
// 5. Added error messages to the require statements for better debugging.