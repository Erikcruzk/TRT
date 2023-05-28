pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if already locked
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked[msg.sender] = true; // lock the user
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // send funds to the user
        locked[msg.sender] = false; // unlock the user
    }
}