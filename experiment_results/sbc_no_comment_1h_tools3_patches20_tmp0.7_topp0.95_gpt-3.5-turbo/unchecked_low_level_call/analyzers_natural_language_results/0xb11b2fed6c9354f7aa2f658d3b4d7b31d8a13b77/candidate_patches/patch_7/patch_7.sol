pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address");
        require(msg.value > 0, "No value sent");

        // Use low level call to forward the function call and value
        (bool success,) = target.call.value(msg.value)(data);
        require(success, "Low level call failed");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function vault() public payable {
        require(msg.sender == tx.origin, "Only externally owned accounts can call this function");

        // Set the owner to the sender and make a deposit
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "No value sent");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(deposits[msg.sender] >= amount, "Insufficient balance");

        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}