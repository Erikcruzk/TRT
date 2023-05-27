pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // Changed creator to public

    mapping(address => uint256) public balances; // Changed balances to public

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // Changed assert to require
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]); // Changed >= to <=
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // Added address(this) to convert to address type
    }
}