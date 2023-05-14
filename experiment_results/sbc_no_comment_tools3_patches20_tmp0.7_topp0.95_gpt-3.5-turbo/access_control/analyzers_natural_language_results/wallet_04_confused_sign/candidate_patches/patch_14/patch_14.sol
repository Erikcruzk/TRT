pragma solidity ^0.8.7;

contract Wallet {
    address payable creator;

    mapping(address => uint256) balances;

    constructor() {
        creator = payable(msg.sender);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function migrateTo(address payable to) public {
        require(creator == msg.sender, "Only the creator can call this function");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available for migration");
        to.transfer(balance);
    }
}