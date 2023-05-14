pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked = true;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        userBalances[msg.sender] = 0;
        locked = false;
    }
} 

//Changes made:
//1. Added a bool variable 'locked' to prevent reentrancy.
//2. Added a require statement to check if 'locked' is false before executing 'withdrawBalance'.
//3. Added a require statement to check if 'amountToWithdraw' is greater than 0.
//4. Moved the assignment statement of 'userBalances[msg.sender]' to after the external call to prevent reentrancy attacks.