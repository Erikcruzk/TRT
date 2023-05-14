pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // made creator public for visibility

    mapping(address => uint256) public balances; // made balances public for visibility

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value; // removed the assert statement since it's unnecessary
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function refund() public {
        uint256 balance = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(balance);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // added "address" to make the code compile
    }
}