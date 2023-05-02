pragma solidity ^0.4.24;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Prevent reentrancy
        locked[msg.sender] = true; // Lock the function
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false; // Unlock the function
    }
}