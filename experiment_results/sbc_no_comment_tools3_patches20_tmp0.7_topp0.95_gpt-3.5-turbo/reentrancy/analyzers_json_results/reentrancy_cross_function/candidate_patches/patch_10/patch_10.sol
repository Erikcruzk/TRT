pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    bool private locked;

    function transfer(address to, uint amount) public {
        require(!locked);
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        locked = true;
        require(msg.sender.call.value(amountToWithdraw)());
        userBalances[msg.sender] = 0;
        locked = false;
    }
} 

// The repaired contract adds a boolean variable "locked" to prevent reentrancy attacks. It also adds require statements to check for sufficient balance and that the contract is not already locked before executing the transfer and withdraw functions. The withdraw function also sets "locked" to true before executing the external call and sets it back to false after the call.