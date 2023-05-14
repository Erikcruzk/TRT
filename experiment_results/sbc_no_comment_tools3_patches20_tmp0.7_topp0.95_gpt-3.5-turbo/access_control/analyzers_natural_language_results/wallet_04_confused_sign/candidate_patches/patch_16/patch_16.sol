pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // Made creator variable public

    mapping(address => uint256) public balances; // Made balances variable public

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // Replaced assert with require
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]); // Reversed the condition
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // Made balance retrieval explicit
    }
}