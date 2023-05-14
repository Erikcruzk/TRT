pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the sender is not already in a withdrawal process
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // check if the sender has any balance to withdraw
        
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true; // lock the sender from further withdrawals until the current one is completed

        bool success = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // unlock the sender after the withdrawal is completed
    }
}