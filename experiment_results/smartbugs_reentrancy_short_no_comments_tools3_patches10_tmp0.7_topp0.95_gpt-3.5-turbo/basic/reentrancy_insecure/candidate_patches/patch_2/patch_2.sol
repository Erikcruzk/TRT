pragma solidity ^0.4.24;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in a transaction
        locked[msg.sender] = true; // Lock the user
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // Send the amount to the user
        locked[msg.sender] = false; // Unlock the user
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
}