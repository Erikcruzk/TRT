pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if already locked
        locked[msg.sender] = true; // lock the function
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update state before external call
        require(msg.sender.call.value(amountToWithdraw)()); // use 'call' to prevent reentrancy
        locked[msg.sender] = false; // unlock the function
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}