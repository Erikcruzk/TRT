pragma solidity ^0.8.7;

contract Wallet {
    address public creator;
    mapping(address => uint256) public balances;

    constructor() {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender], "Deposit overflow");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Failed to send ether");
    }

    function migrateTo(address payable to) public {
        require(creator == msg.sender, "Only creator can migrate");
        (bool success,) = to.call{value: address(this).balance}("");
        require(success, "Failed to send ether");
    }
}