pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        (bool success, ) = target.call.value(msg.value)(data);
        require(success, "Low level call failed");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.5 ether, "Deposit amount must be greater than 0.5 ether");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}