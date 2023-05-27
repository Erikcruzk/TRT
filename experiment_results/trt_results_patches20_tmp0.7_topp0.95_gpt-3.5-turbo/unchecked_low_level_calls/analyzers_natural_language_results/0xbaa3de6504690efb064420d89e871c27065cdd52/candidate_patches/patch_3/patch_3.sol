pragma solidity ^0.4.23;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address.");
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable onlyOwner {
        require(target != address(0), "Invalid target address.");
        bool success = target.call.value(msg.value)(data);
        require(success, "External call failed.");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    constructor() public payable {
        if (msg.sender == tx.origin) {
            owner = msg.sender;
            deposit();
        }
    }

    function deposit() public payable {
        require(msg.value > 0.25 ether, "Deposit amount must be greater than 0.25 ether.");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount, "Insufficient funds.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}