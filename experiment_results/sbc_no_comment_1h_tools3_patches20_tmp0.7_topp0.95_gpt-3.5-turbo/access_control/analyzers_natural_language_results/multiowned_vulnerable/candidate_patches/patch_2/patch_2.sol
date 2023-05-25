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

    function addOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != address(0));
        isOwner[_owner] = true;
        return true;
    }

    function removeOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != root && isOwner[_owner]);
        isOwner[_owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() onlyOwner {
        require(address(this).balance > 0);
        msg.sender.transfer(address(this).balance);
    }

    function() payable {}
}