pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");

        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
    }
} 

// Changes Made
// 1. Updated Solidity version to ^0.8.0
// 2. Added a check to ensure that the user has a balance before withdrawing
// 3. Moved the userBalances[msg.sender] = 0 statement before the external call to prevent reentrancy attacks
// 4. Added error messages to the require statements for better debugging