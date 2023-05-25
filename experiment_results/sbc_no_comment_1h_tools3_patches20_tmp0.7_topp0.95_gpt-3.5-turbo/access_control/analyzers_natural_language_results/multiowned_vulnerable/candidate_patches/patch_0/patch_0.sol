pragma solidity ^0.4.23;

contract MultiOwnable {
    address public root;
    mapping(address => bool) public owners;

    constructor() public {
        root = msg.sender;
        owners[root] = true;
    }

    modifier onlyOwner() {
        require(owners[msg.sender]);
        _;
    }

    function addOwner(address _newOwner) external onlyOwner returns (bool) {
        require(_newOwner != address(0));
        owners[_newOwner] = true;
        return true;
    }

    function removeOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != root && owners[_owner]);
        owners[_owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() onlyOwner public {
        msg.sender.transfer(address(this).balance);
    }

    function() payable public {}
}