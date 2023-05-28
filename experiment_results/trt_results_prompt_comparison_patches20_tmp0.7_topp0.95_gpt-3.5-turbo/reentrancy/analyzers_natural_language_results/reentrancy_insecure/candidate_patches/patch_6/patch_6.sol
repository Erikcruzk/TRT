pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is not already in the middle of another withdraw transaction
        locked[msg.sender] = true; // Lock the user to prevent multiple withdraw transactions

        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update the user's balance before sending funds to prevent reentrancy

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // Unlock the user after the transaction is complete
    }
}