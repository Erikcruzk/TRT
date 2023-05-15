pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Function is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        locked = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");

        userBalances[msg.sender] = 0;
        locked = false;
    }
} 

// Changes made:
// 1. Updated the Solidity compiler version to ^0.8.0.
// 2. Added a boolean variable "locked" to prevent reentrancy attacks.
// 3. Added a require statement to check if the function is locked.
// 4. Added a require statement to check if the user has sufficient balance.
// 5. Moved the "userBalances[msg.sender] = 0" statement after the "locked = false" statement to prevent further reentrancy attacks. 
// 6. Used the new syntax for the call function.