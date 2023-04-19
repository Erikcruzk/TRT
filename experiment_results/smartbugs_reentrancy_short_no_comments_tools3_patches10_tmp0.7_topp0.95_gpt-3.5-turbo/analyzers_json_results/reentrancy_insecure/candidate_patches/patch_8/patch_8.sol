pragma solidity ^0.4.0;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update the user balance before transferring to prevent reentrancy attack
        require(msg.sender.call.value(amountToWithdraw)(""));
    }
}