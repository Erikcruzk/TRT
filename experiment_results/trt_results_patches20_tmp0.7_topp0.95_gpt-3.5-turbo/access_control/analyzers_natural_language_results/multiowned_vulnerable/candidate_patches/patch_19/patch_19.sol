pragma solidity ^0.4.23;

contract MultiOwnable {
    address public root;
    mapping(address => bool) public isOwner;

    constructor() public {
        root = msg.sender;
        isOwner[root] = true;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender]);
        _;
    }

    function addOwner(address newOwner) external onlyOwner returns (bool) {
        require(newOwner != address(0));
        isOwner[newOwner] = true;
        return true;
    }

    function removeOwner(address owner) external onlyOwner returns (bool) {
        require(owner != root);
        isOwner[owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        require(address(this).balance > 0);
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}