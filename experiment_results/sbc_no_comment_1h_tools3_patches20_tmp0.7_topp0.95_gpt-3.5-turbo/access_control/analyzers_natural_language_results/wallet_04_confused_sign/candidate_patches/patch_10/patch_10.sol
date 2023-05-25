pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // changed to public for visibility

    mapping(address => uint256) public balances; // changed to public for visibility

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value > balances[msg.sender]); // changed assert to require for better error handling
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]); // fixed condition to allow withdrawals up to balance
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(msg.sender == creator);
        to.transfer(address(this).balance); // added address() to fix deprecated syntax
    }
}