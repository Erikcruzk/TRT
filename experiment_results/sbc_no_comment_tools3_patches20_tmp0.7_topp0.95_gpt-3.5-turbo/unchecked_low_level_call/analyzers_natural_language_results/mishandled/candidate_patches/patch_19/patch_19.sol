pragma solidity ^0.4.0;

contract SendBack {
    mapping(address => uint) userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        require(msg.sender.call.value(amountToWithdraw)(), "Withdrawal failed");
    }
} 

// Changes made:
// 1. Added 'public' visibility to the 'withdrawBalance' function.
// 2. Replaced the 'send' method with 'call.value' to transfer the funds.
// 3. Added a require statement to check if the transfer was successful.