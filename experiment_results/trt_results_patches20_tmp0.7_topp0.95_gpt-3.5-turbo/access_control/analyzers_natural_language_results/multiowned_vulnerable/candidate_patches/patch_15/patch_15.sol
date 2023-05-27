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

    function addOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0));
        owners[_newOwner] = true;
    }

    function removeOwner(address _ownerToRemove) external onlyOwner {
        require(_ownerToRemove != root);
        owners[_ownerToRemove] = false;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}