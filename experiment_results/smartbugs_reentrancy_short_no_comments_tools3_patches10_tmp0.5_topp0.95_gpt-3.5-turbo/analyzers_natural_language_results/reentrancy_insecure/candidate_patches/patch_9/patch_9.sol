pragma solidity ^0.4.24;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is not already withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true; // set the lock
        userBalances[msg.sender] = 0; // update user balance before making the external call
        (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); // make the external call
        require(success);
        locked[msg.sender] = false; // release the lock
    }
}