pragma solidity ^0.4.24;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address.");
        require(msg.value > 0, "Value must be greater than zero.");
        bool success = target.call.value(msg.value)(data);
        require(success, "External call failed.");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function vault() public payable {
        if (msg.sender == tx.origin) {
            deposits[msg.sender] += msg.value;
        }
    }

    function deposit() public payable {
        if (msg.value > 0.5 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than zero.");
        require(deposits[msg.sender] >= amount, "Insufficient balance.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}