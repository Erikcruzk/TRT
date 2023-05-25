pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is not already in a withdraw process
        locked[msg.sender] = true; // set the user as locked
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update the user balance before transferring funds

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // release the lock after the transfer is done
    }
}