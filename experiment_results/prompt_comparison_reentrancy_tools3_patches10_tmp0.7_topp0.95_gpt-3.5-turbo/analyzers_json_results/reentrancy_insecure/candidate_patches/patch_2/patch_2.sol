pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if user is already in withdraw process
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if user has any balance to withdraw

        locked[msg.sender] = true; // Lock the user to prevent reentrancy
        userBalances[msg.sender] = 0; // Set user balance to 0 before external call

        bool success = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // Unlock the user after external call
    }
}