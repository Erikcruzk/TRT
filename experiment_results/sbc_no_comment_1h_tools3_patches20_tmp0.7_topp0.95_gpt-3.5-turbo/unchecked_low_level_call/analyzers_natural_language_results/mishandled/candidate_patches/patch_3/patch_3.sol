pragma solidity ^0.4.24;

contract SendBack {
    mapping(address => uint) userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        require(msg.sender.call.value(amountToWithdraw)(),"Transaction failed");
    }
} 

// The repaired contract includes the addition of the function visibility specifier "public", and replaces the function send() with call.value() to ensure that the transaction reverts if the external call fails, preventing unexpected behavior. Additionally, a require() statement has been added to ensure that the transaction is reverted if the call fails.