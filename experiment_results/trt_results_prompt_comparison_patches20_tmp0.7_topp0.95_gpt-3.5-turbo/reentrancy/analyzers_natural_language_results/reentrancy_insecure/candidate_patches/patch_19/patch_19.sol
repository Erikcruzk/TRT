pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is already locked
        locked[msg.sender] = true; // lock the user to prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // perform the external call last
        locked[msg.sender] = false; // unlock the user after the external call is completed
    }
}