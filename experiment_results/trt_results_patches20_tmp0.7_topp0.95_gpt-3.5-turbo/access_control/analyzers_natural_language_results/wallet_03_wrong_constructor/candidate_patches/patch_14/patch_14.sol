pragma solidity ^0.8.0;

contract Wallet {
    address payable creator;

    mapping(address => uint256) balances;

    constructor() {
        creator = payable(msg.sender);
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender], "Invalid deposit amount");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        require(address(this).balance >= amount, "Insufficient contract balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function migrateTo(address payable to) public {
        require(creator == msg.sender, "Only the creator can migrate the contract");
        to.transfer(address(this).balance);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}