pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked = false;
    }
} 

// Changes made:
// 1. Added a reentrancy lock to prevent reentrancy attacks
// 2. Checked if the balance of the user is greater than 0 before proceeding with the withdrawal
// 3. Moved the state variable modification before the external call to prevent reentrancy attacks