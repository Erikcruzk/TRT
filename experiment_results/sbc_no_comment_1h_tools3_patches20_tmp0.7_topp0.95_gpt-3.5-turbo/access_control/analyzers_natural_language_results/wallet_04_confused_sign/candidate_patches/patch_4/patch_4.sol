pragma solidity ^0.4.24;

contract Wallet {
    address public creator;
    mapping(address => uint256) public balances;

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount && amount > 0);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance);
    }
}