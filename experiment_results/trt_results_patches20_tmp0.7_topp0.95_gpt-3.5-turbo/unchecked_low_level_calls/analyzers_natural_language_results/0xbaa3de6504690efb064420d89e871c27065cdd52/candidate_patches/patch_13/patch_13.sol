pragma solidity ^0.4.23;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable onlyOwner {
        require(target.call.value(msg.value)(data), "External call failed");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {
        require(msg.sender == tx.origin, "Only externally owned accounts allowed");
        owner = msg.sender;
        deposit();
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.25 ether, "Deposit amount must be greater than 0.25 ether");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount, "Invalid withdrawal amount");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}