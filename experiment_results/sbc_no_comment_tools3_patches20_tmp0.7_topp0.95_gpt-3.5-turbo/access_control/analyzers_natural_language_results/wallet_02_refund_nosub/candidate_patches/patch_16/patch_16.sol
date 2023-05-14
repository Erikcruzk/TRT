pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // Changed visibility to public

    mapping(address => uint256) public balances; // Changed visibility to public

    constructor() public {
        creator = msg.sender;
    }

    function deposit() public payable {
        assert(balances[msg.sender] + msg.value >= balances[msg.sender]); // Changed to greater than or equal to
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount); // Moved transfer after balance update
    }

    function refund() public {
        uint256 balance = balances[msg.sender]; // Added a temporary variable
        balances[msg.sender] = 0; // Set balance to 0 before transfer
        msg.sender.transfer(balance);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // Changed this.balance to address(this).balance
    }
}