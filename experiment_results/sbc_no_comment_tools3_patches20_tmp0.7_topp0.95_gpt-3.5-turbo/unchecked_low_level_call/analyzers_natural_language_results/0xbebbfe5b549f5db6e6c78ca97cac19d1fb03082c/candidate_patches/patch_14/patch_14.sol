pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0)); // Check if target address is not null
        require(msg.value > 0); // Check if value is greater than 0
        require(target.call.value(msg.value)(data)); // Check if low level call was successful
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {
        if (msg.sender == tx.origin) {
            deposit();
        }
    }

    function deposit() public payable {
        require(msg.value > 0.5 ether); // Check if value is greater than 0.5 ether
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount); // Check if amount is greater than 0 and sender has enough balance
        msg.sender.transfer(amount);
        deposits[msg.sender] -= amount;
    }
}