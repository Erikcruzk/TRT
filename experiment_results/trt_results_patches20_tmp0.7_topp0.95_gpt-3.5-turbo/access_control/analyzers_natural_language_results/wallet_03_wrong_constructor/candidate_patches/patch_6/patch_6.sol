pragma solidity ^0.8.0;

contract Wallet {
    address payable creator;

    mapping(address => uint256) balances;

    constructor() {
        creator = payable(msg.sender);
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender], "Invalid deposit");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function migrateTo(address payable to) public {
        require(creator == msg.sender, "Only the creator can migrate the funds");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available to migrate");
        to.transfer(balance);
    }
}