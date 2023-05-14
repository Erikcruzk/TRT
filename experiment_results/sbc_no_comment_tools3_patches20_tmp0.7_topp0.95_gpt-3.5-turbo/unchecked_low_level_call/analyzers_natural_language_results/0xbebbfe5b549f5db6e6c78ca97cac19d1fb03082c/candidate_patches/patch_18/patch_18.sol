pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        owner = _newOwner;
    }

    function proxy(address _target, bytes _data) public payable {
        require(_target != address(0));
        _target.call.value(msg.value)(_data);
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {
        require(msg.sender == tx.origin);
        owner = msg.sender;
        deposit();
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0);
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) public onlyOwner {
        require(_amount > 0 && deposits[msg.sender] >= _amount);
        deposits[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
    }
}