pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isCurrentlyWithdrawing;

    function withdrawBalance() public {
        require(!isCurrentlyWithdrawing[msg.sender]); // prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // ensure user has funds to withdraw
        isCurrentlyWithdrawing[msg.sender] = true; // set flag to true
        userBalances[msg.sender] = 0; // update user balance before external call

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        isCurrentlyWithdrawing[msg.sender] = false; // set flag back to false
    }
}