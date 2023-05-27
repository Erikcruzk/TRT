pragma solidity ^0.4.24;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    address public owner;

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target.call.value(msg.value)(data));
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function Vault() public payable {
        require(msg.sender == tx.origin);
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.5 ether);
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount);
        msg.sender.transfer(amount);
    }
}