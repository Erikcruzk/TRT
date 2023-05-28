pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is already in the process of withdrawing
        locked[msg.sender] = true; // lock the user's account
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // set the user's balance to 0 before sending ether

        require(msg.sender.call.value(amountToWithdraw)()); // send ether to the user

        locked[msg.sender] = false; // unlock the user's account
    }
}