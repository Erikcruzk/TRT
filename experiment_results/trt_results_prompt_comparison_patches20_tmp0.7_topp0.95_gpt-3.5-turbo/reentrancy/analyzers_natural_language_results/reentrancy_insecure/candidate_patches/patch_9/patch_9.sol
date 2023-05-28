pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in the process of withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if the user has any balance to withdraw

        locked[msg.sender] = true; // Lock the user to prevent reentrancy
        userBalances[msg.sender] = 0; // Update the user balance before transfer

        bool success = msg.sender.send(amountToWithdraw); // Use send() instead of call.value() to prevent reentrancy
        require(success);

        locked[msg.sender] = false; // Unlock the user after successful transfer
    }
}