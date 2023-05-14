pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked); // check if reentrancy lock is not locked
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // check if user has balance to withdraw
        locked = true; // set reentrancy lock to prevent further reentrancy calls
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked = false; // release reentrancy lock
    }
}