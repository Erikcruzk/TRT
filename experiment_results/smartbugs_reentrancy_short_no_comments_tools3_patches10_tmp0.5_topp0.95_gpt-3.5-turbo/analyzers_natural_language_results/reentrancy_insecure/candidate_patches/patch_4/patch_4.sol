pragma solidity ^0.4.24;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is already withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true; // lock the user
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // send the ether to the user
        locked[msg.sender] = false; // unlock the user
    }
}