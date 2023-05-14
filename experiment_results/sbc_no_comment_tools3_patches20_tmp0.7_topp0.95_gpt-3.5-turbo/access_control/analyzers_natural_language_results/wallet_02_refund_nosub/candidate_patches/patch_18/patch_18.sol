pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // change to public

    mapping(address => uint256) public balances; // change to public

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // change assert to require
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function refund() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0); // add require statement to check balance is greater than zero
        balances[msg.sender] = 0;
        msg.sender.transfer(balance);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        uint256 balance = address(this).balance;
        require(balance > 0); // add require statement to check balance is greater than zero
        to.transfer(balance);
    }
}