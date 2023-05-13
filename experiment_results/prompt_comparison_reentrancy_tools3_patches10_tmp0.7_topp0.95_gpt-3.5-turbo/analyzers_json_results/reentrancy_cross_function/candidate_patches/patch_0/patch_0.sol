pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
} 

// The repaired contract adds a locked mapping to keep track of whether the user has already withdrawn their balance and prevents reentrancy attacks. It also includes a require statement to check whether the user is already locked before executing the withdrawBalance function.