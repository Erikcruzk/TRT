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

    function addOwner(address _owner) external returns (bool) {
        require(_owner != address(0));
        require(msg.sender == root || owners[msg.sender] == true); // Only root or existing owners can add new owners
        owners[_owner] = true;
        return true;
    }

    function removeOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != root); // Root cannot be removed
        owners[_owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() onlyOwner public {
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}