pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
} 

//The repaired contract includes a new mapping 'locked' which is used to prevent reentrancy attacks. The function withdrawBalance() now checks whether the user is currently locked before performing any transactions. If the user is not locked, then the function proceeds to transfer the amount to the user's account and sets the lock to false.