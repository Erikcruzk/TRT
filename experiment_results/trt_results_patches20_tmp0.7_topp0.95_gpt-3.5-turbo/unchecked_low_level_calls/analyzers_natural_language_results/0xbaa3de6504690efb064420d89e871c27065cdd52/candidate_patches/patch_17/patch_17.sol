pragma solidity ^0.4.23;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    address owner;

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
        require(success);
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function Vault() public payable {
        if (msg.sender == tx.origin) {
            owner = msg.sender;
            deposit();
        }
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