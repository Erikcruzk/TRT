pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Function is locked");
        locked = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        userBalances[msg.sender] = 0;
        locked = false;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Failed to send ether");
    }
} 

//Changes made:
//1. Updated the Solidity version to ^0.8.0
//2. Added a 'locked' boolean variable to prevent reentrancy attacks
//3. Added a check to ensure that the user has sufficient balance before withdrawing
//4. Moved the userBalances[msg.sender] = 0; line before the 'locked' variable is set to false
//5. Used the new syntax for sending ether using call{value: amount}("") and added an error message to the require statement.