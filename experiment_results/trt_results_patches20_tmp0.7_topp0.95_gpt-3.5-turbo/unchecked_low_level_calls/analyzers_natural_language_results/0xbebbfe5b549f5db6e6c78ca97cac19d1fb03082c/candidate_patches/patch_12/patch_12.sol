pragma solidity ^0.4.24;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    address owner = msg.sender;

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target.call.value(msg.value)(data));
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public Deposits;

    function() public payable {}

    function Vault() public payable {
        if (msg.sender == tx.origin) {
            owner = msg.sender;
            deposit();
        }
    }

    function deposit() public payable {
        if (msg.value > 0.5 ether) {
            Deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && Deposits[msg.sender] >= amount);
        Deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}