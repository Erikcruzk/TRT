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

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable onlyOwner {
        require(target.call.value(msg.value)(data));
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > 0.25 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount);
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}