pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdrawal already in progress");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        locked[msg.sender] = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");

        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Updated the version of Solidity to 0.8.0
// 2. Added a "locked" mapping to prevent reentrancy attacks
// 3. Added a check to ensure that the user has sufficient balance before withdrawing
// 4. Added error messages to the require statements for better debugging
// 5. Used the new syntax for sending ether in Solidity 0.8.0