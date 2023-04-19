pragma solidity ^0.4.24;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is already withdrawing
        locked[msg.sender] = true; // lock the user from re-entry
        
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // zero out user balance before external call
        require(msg.sender.call.value(amountToWithdraw)()); // external call to withdraw funds
        locked[msg.sender] = false; // unlock the user after external call is complete
    }
}