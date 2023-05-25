pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // made creator public

    mapping(address => uint256) balances;

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == creator); // added access control
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(msg.sender == creator);
        to.transfer(this.balance);
    }
}