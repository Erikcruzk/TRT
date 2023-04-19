pragma solidity ^0.4.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already withdrawing their balance
        locked[msg.sender] = true; // Lock the user's account to prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update the user's balance before sending ether to prevent reentrancy
        require(msg.sender.call.value(amountToWithdraw)("")); // Send ether to the user
        locked[msg.sender] = false; // Unlock the user's account after the ether has been sent
    }
}