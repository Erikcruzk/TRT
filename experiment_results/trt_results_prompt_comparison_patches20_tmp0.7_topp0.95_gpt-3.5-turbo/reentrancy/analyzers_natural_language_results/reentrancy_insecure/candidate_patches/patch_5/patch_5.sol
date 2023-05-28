pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // prevent reentrancy
        locked[msg.sender] = true; // lock the sender to prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false; // release the lock
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
}