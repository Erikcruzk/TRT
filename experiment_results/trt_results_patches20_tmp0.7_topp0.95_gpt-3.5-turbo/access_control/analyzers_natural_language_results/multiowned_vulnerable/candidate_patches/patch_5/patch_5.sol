pragma solidity ^0.4.23;

contract MultiOwnable {
    address public root;
    mapping(address => bool) public isOwner;

    constructor() public {
        root = msg.sender;
        isOwner[root] = true;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender] == true);
        _;
    }

    function newOwner(address _owner) external returns (bool) {
        require(_owner != address(0));
        require(isOwner[msg.sender] == true);
        isOwner[_owner] = true;
        return true;
    }

    function deleteOwner(address _owner) external onlyOwner returns (bool) {
        require(
            isOwner[_owner] == true &&
                (msg.sender == root || msg.sender == _owner)
        );
        isOwner[_owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}