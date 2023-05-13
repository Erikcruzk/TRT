pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        require(msg.sender.call.value(amountToWithdraw)());
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
} 

// This repaired contract uses a mutex lock to prevent reentrancy attacks. The `locked` mapping keeps track of whether an address is currently executing the `withdrawBalance` function, and if so, it prevents any further calls until the function execution is complete. The state changes are also moved after the external call to prevent any reentrancy vulnerabilities.