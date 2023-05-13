pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked = true;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked = false;
    }
} 

// Changes Made:
// - Added a boolean variable 'locked' to prevent reentrancy attacks
// - Moved the modification of 'userBalances' before the external call to prevent reentrancy attacks
// - Added a require statement to check if the contract is locked before executing the function to prevent reentrancy attacks.