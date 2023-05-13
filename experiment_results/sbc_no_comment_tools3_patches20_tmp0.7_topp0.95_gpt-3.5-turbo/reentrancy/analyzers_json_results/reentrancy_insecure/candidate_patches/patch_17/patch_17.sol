pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the sender is already in another withdraw process
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true; // Lock the sender to prevent reentrancy

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // Unlock the sender after the withdraw process is completed
    }
} 

//This contract fixes the reentrancy vulnerability by adding a lock mechanism to prevent the same address from calling the function again before the previous call has completed. It also moves the state modification before the external call to prevent the possibility of reentrant calls modifying the state.