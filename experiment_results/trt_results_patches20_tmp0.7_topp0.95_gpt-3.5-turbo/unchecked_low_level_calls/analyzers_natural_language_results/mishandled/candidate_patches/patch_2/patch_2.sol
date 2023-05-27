pragma solidity ^0.4.24;

contract SendBack {
    mapping(address => uint) userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        require(msg.sender.call.value(amountToWithdraw)());
    }
} 

// Changes made:
// 1. Added "public" to function declaration to explicitly specify visibility
// 2. Changed "send" to "call.value" to explicitly send Ether to the caller
// 3. Added "require" statement to check if the external call was successful.