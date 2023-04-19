pragma solidity ^0.4.24;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is already in a transaction
        locked[msg.sender] = true; // lock the user
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update user balance before sending
        msg.sender.transfer(amountToWithdraw); // send the balance to the user
        locked[msg.sender] = false; // unlock the user
    }
}