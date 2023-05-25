pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already withdrawing funds
        locked[msg.sender] = true; // Lock the user's account
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update user balance before external call

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false; // Unlock the user's account
    }
}