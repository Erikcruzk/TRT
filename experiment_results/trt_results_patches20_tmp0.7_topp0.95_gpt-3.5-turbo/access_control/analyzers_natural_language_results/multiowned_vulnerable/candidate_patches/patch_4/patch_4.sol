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

    function addOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != address(0) && !owners[_owner]);
        owners[_owner] = true;
        return true;
    }

    function removeOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != address(0) && owners[_owner] && msg.sender != _owner && msg.sender != root);
        owners[_owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}