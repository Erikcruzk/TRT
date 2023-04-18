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
// 1. Updated the Solidity version
// 2. Moved the state variable update before the external call
// 3. Used the new syntax for external call with value
// 4. Removed unnecessary comments