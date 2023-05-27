pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner of the contract can perform this action");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        require(_owner != address(0), "Invalid address");
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable onlyOwner {
        require(target != address(0), "Invalid address");
        require(target.call.value(msg.value)(data), "External call failed");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {
        require(msg.sender == tx.origin, "Only external accounts can deploy this contract");
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function() public payable {
        deposit();
    }
}