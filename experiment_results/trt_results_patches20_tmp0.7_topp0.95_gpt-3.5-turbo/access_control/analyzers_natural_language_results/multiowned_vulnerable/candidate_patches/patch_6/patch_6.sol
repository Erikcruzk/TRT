pragma solidity ^0.4.23;

contract MultiOwnable {
    address public root;
    mapping(address => bool) public isOwner;

    event NewOwner(address indexed _owner, address indexed _addedBy);
    event RemovedOwner(address indexed _owner, address indexed _removedBy);

    constructor() public {
        root = msg.sender;
        isOwner[root] = true;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender]);
        _;
    }

    function addOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != address(0) && !isOwner[_owner]);
        isOwner[_owner] = true;
        emit NewOwner(_owner, msg.sender);
        return true;
    }

    function removeOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != address(0) && isOwner[_owner] && _owner != root);
        isOwner[_owner] = false;
        emit RemovedOwner(_owner, msg.sender);
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}