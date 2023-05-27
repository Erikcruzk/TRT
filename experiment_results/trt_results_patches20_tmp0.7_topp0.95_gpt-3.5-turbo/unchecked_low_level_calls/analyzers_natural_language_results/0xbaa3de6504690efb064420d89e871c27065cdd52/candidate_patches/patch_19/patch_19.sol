pragma solidity ^0.8.0;

contract Proxy {
    address private _owner;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        _owner = msg.sender;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        _owner = newOwner;
    }

    function proxy(address target, bytes memory data) public payable onlyOwner {
        (bool success,) = target.call{value: msg.value}(data);
        require(success, "External call failed");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() payable {}

    function deposit() public payable {
        if (msg.value > 0.25 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount, "Invalid amount");
        deposits[msg.sender] -= amount;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal failed");
    }
}