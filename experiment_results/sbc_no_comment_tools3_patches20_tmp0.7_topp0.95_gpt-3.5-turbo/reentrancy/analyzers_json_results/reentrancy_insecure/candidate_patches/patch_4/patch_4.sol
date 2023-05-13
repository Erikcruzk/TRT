pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Reentrant call detected!");
        uint amountToWithdraw = userBalances[msg.sender];

        locked = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
        userBalances[msg.sender] = 0;
        locked = false;
    }
} 

// Changes Made:
// 1. Added a boolean variable 'locked' to prevent reentrancy attacks.
// 2. Added a check to ensure that the contract is not already locked before executing the function.
// 3. Used the new syntax for external calls with value. 
// 4. Moved the state variable modification to after the external call to prevent reentrancy attacks.