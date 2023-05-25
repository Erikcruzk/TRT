pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // added public visibility

    mapping(address => uint256) public balances; // added public visibility

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // changed assert to require
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function refund() public {
        require(balances[msg.sender] > 0); // added check for non-zero balance
        msg.sender.transfer(balances[msg.sender]);
        balances[msg.sender] = 0; // added resetting balance to zero
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // changed this.balance to address(this).balance
    }
}