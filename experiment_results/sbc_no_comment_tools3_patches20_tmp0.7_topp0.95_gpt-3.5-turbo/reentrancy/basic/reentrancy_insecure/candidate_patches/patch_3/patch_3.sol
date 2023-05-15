pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // ensure the user has a balance to withdraw

        userBalances[msg.sender] = 0; // update user balance before sending funds

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
    }
} 

// Changes Made:
// 1. Updated pragma version to ^0.8.0
// 2. Added a check to ensure the user has a balance to withdraw
// 3. Updated the order of updating the user balance and sending funds to prevent reentrancy attacks.