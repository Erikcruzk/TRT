pragma solidity ^0.4.24;

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
        require(target != address(0));
        require(msg.value > 0);
        bool success;
        bytes4 sig = bytes4(keccak256("proxy(address,bytes)"));
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            success := call(gas, target, msg.value, ptr, calldatasize, 0, 0)
        }
        require(success);
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function vault() public payable {
        if (msg.sender == tx.origin) {
            owner = msg.sender;
            deposit();
        }
    }

    function deposit() public payable {
        if (msg.value > 0.5 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount);
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}