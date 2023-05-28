pragma solidity ^0.8.0;

contract Wallet {
    address public creator;
    mapping(address => uint256) public balances;

    constructor() {
        creator = msg.sender;
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
        require(creator == msg.sender, "Only creator can migrate");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to migrate");
        to.transfer(balance);
    }
}