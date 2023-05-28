pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if user is not already in a withdrawal process
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true; // Lock the user's account

        require(amountToWithdraw > 0); // Check if the user has balance to withdraw

        userBalances[msg.sender] = 0; // Update the user's balance to 0 before transferring
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success); // Check if transfer was successful

        locked[msg.sender] = false; // Unlock the user's account
    }
}