pragma solidity ^0.4.24;

contract Wallet {
    address public creator;
    mapping(address => uint256) public balances;

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // Use require() instead of assert()
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]); // Fix the condition
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // Use address(this).balance to get the contract's balance
    }
}