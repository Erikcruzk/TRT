pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) {
        require(!locked[msg.sender]);
        require(userBalances[msg.sender] >= amount);
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

// The repaired contract adds a 'locked' mapping to keep track of whether a user is currently executing a transaction. This prevents reentrancy attacks. Additionally, the transfer and withdraw functions are modified to include the 'locked' check and to transfer ether to the user after updating the state variables to prevent the possibility of a reentrancy attack.