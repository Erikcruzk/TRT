pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Reentrancy protection");
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a reentrancy protection mechanism by using a boolean mapping "locked" to keep track of whether the user is currently executing the withdrawBalance function or not.
// 2. Moved the state variable modification before the external call to prevent any reentrancy vulnerability.