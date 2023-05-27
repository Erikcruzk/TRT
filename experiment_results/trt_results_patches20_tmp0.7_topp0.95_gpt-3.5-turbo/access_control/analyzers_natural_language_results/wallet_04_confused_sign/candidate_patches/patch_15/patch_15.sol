pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // changed from private to public

    mapping(address => uint256) public balances; // changed from private to public

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value; // simplified logic
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]); // changed to less than or equal to
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // changed to use address(this)
    }
}