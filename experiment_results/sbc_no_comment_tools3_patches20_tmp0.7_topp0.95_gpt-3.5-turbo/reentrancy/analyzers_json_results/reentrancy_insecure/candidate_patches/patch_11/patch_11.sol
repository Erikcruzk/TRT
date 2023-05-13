pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lock;

    function withdrawBalance() public {
        require(!lock[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        lock[msg.sender] = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        lock[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a lock to prevent reentrancy attacks.
// 2. Moved the state change before the external call to prevent reentrancy attacks.
// 3. Updated the Solidity version to ^0.4.24.