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

    function addOwner(address _owner) external onlyOwner {
        require(_owner != address(0));
        owners[_owner] = true;
    }

    function removeOwner(address _owner) external onlyOwner {
        require(_owner != root);
        owners[_owner] = false;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}