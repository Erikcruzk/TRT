pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the sender is already in the withdraw process
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if the user has balance to withdraw
        locked[msg.sender] = true; // Lock the sender
        userBalances[msg.sender] = 0; // Set the balance to 0 before sending the funds
        require(msg.sender.call.value(amountToWithdraw)()); // Send the funds
        locked[msg.sender] = false; // Unlock the sender
    }
}