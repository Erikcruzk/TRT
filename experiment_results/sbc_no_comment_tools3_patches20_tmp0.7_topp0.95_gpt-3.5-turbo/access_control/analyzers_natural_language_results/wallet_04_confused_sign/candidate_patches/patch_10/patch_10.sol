pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // Made creator public to access it from outside

    mapping(address => uint256) public balances; // Made balances public to access it from outside

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // Replaced assert with require
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]); // Fixed the condition to check if the amount is less than or equal to balance
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // Added address(this) to access the contract's balance
    }
}