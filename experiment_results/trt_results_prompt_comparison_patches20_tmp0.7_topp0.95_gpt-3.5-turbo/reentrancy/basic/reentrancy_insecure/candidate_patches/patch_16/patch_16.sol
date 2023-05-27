pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Function is locked");
        locked = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Failed to transfer funds");

        locked = false;
    }

    function depositBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// Changes made:
// 1. Added a 'locked' boolean variable to prevent reentrancy attacks
// 2. Added a check to ensure that the user has sufficient balance before withdrawing
// 3. Reordered the code to update the user balance before transferring funds to prevent a possible reentrancy attack
// 4. Added a deposit function to allow users to add to their balance
// 5. Added a getBalance function to allow users to check their balance.