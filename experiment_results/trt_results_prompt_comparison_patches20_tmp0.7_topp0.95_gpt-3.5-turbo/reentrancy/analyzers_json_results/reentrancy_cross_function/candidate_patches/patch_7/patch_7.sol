pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) {
        require(userBalances[msg.sender] >= amount);
        require(!locked[msg.sender] && !locked[to]);
        
        locked[msg.sender] = true;
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);

        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
} 

// In the repaired contract, a mutex pattern is used to prevent reentrancy attacks. A mutex is a lock that is used to prevent concurrent access to a shared resource. The 'locked' mapping is used to keep track of whether an address is currently executing a function and has not yet finished executing it. If a function is currently being executed by an address, any subsequent calls to that function from the same address will be prevented. This ensures that the function is executed atomically and prevents any reentrancy attacks.