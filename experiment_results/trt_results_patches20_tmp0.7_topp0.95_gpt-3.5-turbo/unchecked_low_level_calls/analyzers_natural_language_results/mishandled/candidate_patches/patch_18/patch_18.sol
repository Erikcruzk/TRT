pragma solidity ^0.4.24;

contract SendBack {
    mapping(address => uint) userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        require(msg.sender.call.value(amountToWithdraw)(), "Withdrawal failed");
    }
} 

//Changes Made:
//1. Added function visibility specifier public to the withdrawBalance() function.
//2. Replaced send() with call.value() to send ether.
//3. Added require() to check if the withdrawal was successful.