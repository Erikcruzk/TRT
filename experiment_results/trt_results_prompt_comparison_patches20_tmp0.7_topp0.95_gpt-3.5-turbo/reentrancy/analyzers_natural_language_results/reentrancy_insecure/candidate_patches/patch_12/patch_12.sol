pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isCurrentlyWithdrawing;

    function withdrawBalance() public {
        require(!isCurrentlyWithdrawing[msg.sender]); // prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // ensure user has balance to withdraw

        isCurrentlyWithdrawing[msg.sender] = true; // mark user as currently withdrawing
        userBalances[msg.sender] = 0; // update user balance to 0 before transfer

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success); // ensure transfer was successful

        isCurrentlyWithdrawing[msg.sender] = false; // mark user as finished withdrawing
    }
}