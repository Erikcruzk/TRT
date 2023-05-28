pragma solidity ^0.4.24;

contract Proxy {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address");
        require(msg.value > 0, "No value sent");
        require(target.call.value(msg.value)(data), "Low level call failed");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function vault() public payable {
        require(msg.sender == tx.origin, "Only externally owned accounts can perform this action");
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.5 ether, "Deposit amount should be greater than 0.5 ether");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Invalid withdrawal amount");
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}