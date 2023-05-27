pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // make creator public for visibility

    mapping(address => uint256) public balances; // make balances public for visibility

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // change assert to require for better error handling
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount); // move transfer after updating balance
    }

    function refund() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0); // require non-zero balance
        balances[msg.sender] = 0;
        msg.sender.transfer(balance);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // use address(this) to get contract balance
    }
}