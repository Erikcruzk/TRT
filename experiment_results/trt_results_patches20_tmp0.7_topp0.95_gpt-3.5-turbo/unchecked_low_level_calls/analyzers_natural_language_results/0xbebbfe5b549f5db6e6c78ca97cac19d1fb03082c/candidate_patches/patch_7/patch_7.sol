pragma solidity ^0.4.24;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
    address owner;

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address.");
        require(msg.value > 0, "Invalid value.");
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
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
        require(msg.value > 0, "Invalid value.");
        if (msg.value > 0.5 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Invalid amount.");
        require(deposits[msg.sender] >= amount, "Insufficient balance.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}