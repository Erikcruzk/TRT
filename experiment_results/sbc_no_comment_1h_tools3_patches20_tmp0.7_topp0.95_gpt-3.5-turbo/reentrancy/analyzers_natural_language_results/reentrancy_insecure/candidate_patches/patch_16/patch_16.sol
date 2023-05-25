pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if the user has a balance to withdraw
        locked[msg.sender] = true; // Set the user as locked

        bool success = msg.sender.call.value(amountToWithdraw)("");
        require(success); // Check if the transfer was successful

        userBalances[msg.sender] = 0; // Update the user's balance
        locked[msg.sender] = false; // Reset the user's status
    }
}