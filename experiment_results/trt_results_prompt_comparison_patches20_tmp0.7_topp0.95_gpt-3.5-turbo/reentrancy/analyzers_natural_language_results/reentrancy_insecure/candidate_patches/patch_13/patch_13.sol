pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // prevent withdrawing 0 balance

        locked[msg.sender] = true; // lock the sender to prevent reentrancy
        userBalances[msg.sender] = 0; // update balance before transfer
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // unlock the sender after transfer
    }
}