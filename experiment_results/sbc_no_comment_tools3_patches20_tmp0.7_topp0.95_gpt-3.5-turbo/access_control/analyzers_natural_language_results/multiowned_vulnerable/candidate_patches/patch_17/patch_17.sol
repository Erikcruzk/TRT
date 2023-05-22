pragma solidity ^0.4.23;

contract MultiOwnable {
    address public root;
    mapping(address => bool) public owners;

    constructor() public {
        root = msg.sender;
        owners[root] = true;
    }

    modifier onlyOwner() {
        require(owners[msg.sender] == true);
        _;
    }

    function addOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != address(0));
        owners[_owner] = true;
        return true;
    }

    function removeOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != root && owners[_owner] == true);
        owners[_owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() onlyOwner public {
        msg.sender.transfer(this.balance);
    }

    function() public payable {}
}