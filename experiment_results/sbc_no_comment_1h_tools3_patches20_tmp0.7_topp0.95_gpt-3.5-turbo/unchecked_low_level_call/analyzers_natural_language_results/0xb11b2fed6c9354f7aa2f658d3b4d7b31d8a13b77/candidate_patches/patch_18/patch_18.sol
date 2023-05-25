pragma solidity ^0.4.24;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0));
        require(msg.value > 0);
        require(target.call.value(msg.value)(data));
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {
        require(msg.value > 0);
        owner = msg.sender;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.5 ether);
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount);
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}