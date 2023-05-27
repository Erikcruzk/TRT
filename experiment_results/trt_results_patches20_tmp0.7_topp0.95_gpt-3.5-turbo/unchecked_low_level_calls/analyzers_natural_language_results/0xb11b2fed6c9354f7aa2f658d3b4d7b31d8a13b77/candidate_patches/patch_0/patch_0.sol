pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this operation");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable onlyOwner {
        require(target != address(0), "Invalid address");
        require(target.call.value(msg.value)(data), "External call failed");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function vault() public payable {
        if (msg.sender == tx.origin) {
            owner = msg.sender;
            deposit();
        }
    }

    function deposit() public payable {
        if (msg.value > 0.5 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount, "Invalid amount");
        msg.sender.transfer(amount);
        deposits[msg.sender] -= amount;
    }
}