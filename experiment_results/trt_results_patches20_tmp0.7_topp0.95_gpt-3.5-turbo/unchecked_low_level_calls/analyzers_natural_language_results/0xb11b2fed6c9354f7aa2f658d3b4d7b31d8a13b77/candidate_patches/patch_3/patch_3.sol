pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be a null address.");
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable onlyOwner {
        require(target != address(0), "Target address cannot be a null address.");
        require(target.call.value(msg.value)(data), "External call failed.");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {}

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount cannot be zero.");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount cannot be zero.");
        require(amount <= deposits[msg.sender], "Insufficient funds.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}