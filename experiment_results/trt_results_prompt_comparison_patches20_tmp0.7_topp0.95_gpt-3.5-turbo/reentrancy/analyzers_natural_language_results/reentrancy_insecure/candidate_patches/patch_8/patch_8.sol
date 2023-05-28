pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if user is already in a withdrawal process
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if user has balance to withdraw
        locked[msg.sender] = true; // Lock the user's account during withdrawal process

        bool success = msg.sender.send(amountToWithdraw); // Send the balance to the user's address
        require(success);

        userBalances[msg.sender] = 0; // Set the user's balance to zero
        locked[msg.sender] = false; // Unlock the user's account after withdrawal process
    }
}