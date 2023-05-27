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

    function addOwner(address _owner) external onlyOwner {
        require(_owner != address(0));
        isOwner[_owner] = true;
    }

    function removeOwner(address _owner) external onlyOwner {
        require(_owner != root && isOwner[_owner]);
        isOwner[_owner] = false;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        require(address(this).balance > 0);
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}