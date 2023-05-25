pragma solidity ^0.4.23;

contract Proxy {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address");
        require(target.call.value(msg.value)(data), "External call failed");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {
        require(msg.sender == tx.origin, "Contract can only be deployed by an externally-owned account");
        owner = msg.sender;
        deposit();
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}