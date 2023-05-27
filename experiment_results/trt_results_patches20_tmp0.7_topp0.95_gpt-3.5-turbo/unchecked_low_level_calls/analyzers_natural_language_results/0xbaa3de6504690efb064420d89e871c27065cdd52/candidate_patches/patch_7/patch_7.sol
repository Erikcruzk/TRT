pragma solidity ^0.4.23;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == Owner);
        _;
    }
    address Owner = msg.sender;

    function transferOwner(address _owner) public onlyOwner {
        Owner = _owner;
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
            Owner = msg.sender;
            deposit();
        }
    }

    function deposit() public payable {
        if (msg.value > 0.25 ether) {
            Deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && Deposits[msg.sender] >= amount);
        msg.sender.transfer(amount);
    }
}