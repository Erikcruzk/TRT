pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked[msg.sender] = true;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
} 

// Changes made:
// - Added a mapping to keep track of locked users to prevent reentrancy attacks
// - Added a check to ensure user has a non-zero balance before withdrawing
// - Added a lock before the external call and released after it to prevent reentrancy attacks
// - Updated the Solidity version to 0.4.24 (a more recent version)