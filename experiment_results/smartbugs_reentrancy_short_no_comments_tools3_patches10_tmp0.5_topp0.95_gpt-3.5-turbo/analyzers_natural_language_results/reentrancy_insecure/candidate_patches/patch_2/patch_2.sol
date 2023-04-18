pragma solidity ^0.4.24;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is not already in a withdraw process
        locked[msg.sender] = true; // lock the user to prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update the balance before sending ether
        (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); // send ether
        require(success);
        locked[msg.sender] = false; // unlock the user after the transaction is completed
    }
}