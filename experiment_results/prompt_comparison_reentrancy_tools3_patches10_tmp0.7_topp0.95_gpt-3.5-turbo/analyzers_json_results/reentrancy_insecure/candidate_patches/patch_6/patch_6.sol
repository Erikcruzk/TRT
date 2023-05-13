pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
} 

// The repaired contract adds a reentrancy lock to prevent reentrancy attacks. The lock is added to the user's address in the form of a boolean mapping called `locked`. When the `withdrawBalance` function is called, it checks if the user's address is already locked. If it is, the function returns. Otherwise, it sets the lock to true, withdraws the balance, sets the balance to zero, sets the lock to false, and then sends the balance to the user's address. This ensures that no state modifications are executed after the call and that reentrancy guards are in place.