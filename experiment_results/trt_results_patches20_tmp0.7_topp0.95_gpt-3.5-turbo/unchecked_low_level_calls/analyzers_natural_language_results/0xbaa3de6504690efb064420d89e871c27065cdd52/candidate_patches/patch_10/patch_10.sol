pragma solidity ^0.4.23;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    address owner;

    function transferOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        owner = _newOwner;
    }

    function proxy(address _target, bytes _data) public payable onlyOwner {
        require(_target != address(0));

        bool success;
        bytes memory returnData;
        (success, returnData) = _target.call.value(msg.value)(_data);
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

    function withdraw(uint256 _amount) public onlyOwner {
        require(_amount > 0 && deposits[msg.sender] >= _amount);
        deposits[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
    }
}