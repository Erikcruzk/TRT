pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if locked
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update state before external call
        locked[msg.sender] = true; // set lock

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // release lock
    }
}