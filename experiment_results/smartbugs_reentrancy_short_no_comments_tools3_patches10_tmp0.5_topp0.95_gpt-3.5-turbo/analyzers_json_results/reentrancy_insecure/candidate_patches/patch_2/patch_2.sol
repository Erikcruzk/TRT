pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
    }
}

// Changes Made:
// 1. Updated the Solidity version to 0.8.0.
// 2. Moved the state variable update before the external call to prevent reentrancy.
// 3. Added curly braces and "value" keyword to the external call for better readability and security.