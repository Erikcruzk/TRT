pragma solidity ^0.8.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdraw already in progress");
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdraw failed");
        locked[msg.sender] = false;
    }
} 

// Changes made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Added a boolean mapping to keep track of whether a withdrawal is in progress for an address
// 3. Added a check to ensure that a withdrawal is not already in progress for the same address
// 4. Moved the balance check and balance update before the external call to prevent reentrancy attacks
// 5. Added error messages to the require statements for better debugging and usability