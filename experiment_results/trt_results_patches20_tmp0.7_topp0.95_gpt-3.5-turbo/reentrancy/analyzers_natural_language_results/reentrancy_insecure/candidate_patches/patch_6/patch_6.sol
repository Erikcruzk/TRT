pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the sender is not already in a withdrawal process
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if the sender has any balance to withdraw

        locked[msg.sender] = true; // Lock the sender to prevent reentrancy

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        userBalances[msg.sender] = 0;

        locked[msg.sender] = false; // Unlock the sender after the withdrawal is complete
    }
}