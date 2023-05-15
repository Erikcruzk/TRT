pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Withdraw is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        locked = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Failed to withdraw balance");
        userBalances[msg.sender] = 0;
        locked = false;
    }
    
    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// Changes Made:
// 1. Updated Solidity version to ^0.8.0.
// 2. Added a boolean variable 'locked' to prevent reentrancy attacks.
// 3. Added a check for balance before withdrawal.
// 4. Added deposit and getBalance functions for testing purposes.