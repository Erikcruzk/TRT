pragma solidity ^0.8.0;

contract Wallet {
    address payable public creator;

    mapping(address => uint256) public balances;

    constructor() {
        creator = payable(msg.sender);
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]);
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function refund() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance to refund");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }

    function migrateTo(address payable to) public {
        require(creator == msg.sender, "Only creator can migrate funds");
        uint256 balance = address(this).balance;
        creator.transfer(balance);
        creator = to;
    }
}