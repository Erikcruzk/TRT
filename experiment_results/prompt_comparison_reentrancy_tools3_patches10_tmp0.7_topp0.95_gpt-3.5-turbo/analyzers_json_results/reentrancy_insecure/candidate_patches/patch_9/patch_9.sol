pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is already withdrawing
        locked[msg.sender] = true; // lock the user's account
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update balance before external call

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // unlock the user's account
    }
}