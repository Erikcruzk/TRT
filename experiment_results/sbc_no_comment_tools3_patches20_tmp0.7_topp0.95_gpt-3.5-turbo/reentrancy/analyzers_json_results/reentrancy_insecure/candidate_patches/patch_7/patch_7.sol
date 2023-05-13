pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Reentrancy protection");
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);

        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a mapping to keep track of locked accounts to prevent reentrancy attacks.
// 2. Moved the write to persistent state before the external call.
// 3. Updated the syntax for the external call to the latest version of Solidity.