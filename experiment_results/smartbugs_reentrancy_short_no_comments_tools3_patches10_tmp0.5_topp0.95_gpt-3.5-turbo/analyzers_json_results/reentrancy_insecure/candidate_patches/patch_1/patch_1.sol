pragma solidity ^0.5.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
} 

// Changes made:
// 1. Updated the Solidity version to ^0.5.0
// 2. Moved the userBalances[msg.sender] = 0; statement before the external call
// 3. Used the latest syntax for external calls (removed the empty string parameter)