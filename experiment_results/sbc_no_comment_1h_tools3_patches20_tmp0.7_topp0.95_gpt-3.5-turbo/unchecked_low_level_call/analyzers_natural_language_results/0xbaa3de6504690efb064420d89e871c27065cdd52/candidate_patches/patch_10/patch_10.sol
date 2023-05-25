pragma solidity ^0.4.23;

contract Proxy {
    address public Owner;

    modifier onlyOwner() {
        require(msg.sender == Owner, "Only the contract owner can execute this function");
        _;
    }

    constructor() public {
        Owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        require(_owner != address(0), "Invalid address");
        Owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address");
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
        require(success, "External call failed");
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

    function() public payable {}

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        if (msg.value > 0.25 ether) {
            Deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(Deposits[msg.sender] >= amount, "Insufficient balance");
        Deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}