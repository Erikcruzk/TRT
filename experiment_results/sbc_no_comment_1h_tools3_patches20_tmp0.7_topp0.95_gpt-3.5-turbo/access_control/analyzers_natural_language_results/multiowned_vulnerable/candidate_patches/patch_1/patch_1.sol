pragma solidity ^0.8.0;

contract MultiOwnable {
    address public root;
    mapping(address => bool) public owners;

    constructor() {
        root = msg.sender;
        owners[root] = true;
    }

    modifier onlyOwner() {
        require(owners[msg.sender], "Only owners can call this function");
        _;
    }

    function addOwner(address _owner) external onlyOwner {
        require(_owner != address(0), "Invalid owner address");
        owners[_owner] = true;
    }

    function removeOwner(address _owner) external onlyOwner {
        require(_owner != address(0), "Invalid owner address");
        require(msg.sender != _owner, "Cannot remove self");
        require(owners[_owner], "Address is not an owner");
        owners[_owner] = false;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() external onlyOwner {
        require(address(this).balance > 0, "Insufficient balance");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}