pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // reentrancy guard
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true; // set lock before external call
        
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        
        locked[msg.sender] = false; // release lock after external call
    }
}