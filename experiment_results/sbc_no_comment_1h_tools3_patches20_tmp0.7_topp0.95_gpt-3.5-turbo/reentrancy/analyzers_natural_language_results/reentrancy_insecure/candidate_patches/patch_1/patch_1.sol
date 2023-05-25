pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); //check if the user is already in a transaction
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true; //set the user to be in a transaction
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false; //set the user to be out of a transaction
    }
}