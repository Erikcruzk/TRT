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

    function newOwner(address _owner) external onlyOwner {
        require(_owner != address(0), "Invalid owner address");
        owners[_owner] = true;
    }

    function deleteOwner(address _owner) external onlyOwner {
        require(
            owners[_owner] && (_owner != root || msg.sender == root),
            "Cannot delete root owner"
        );
        owners[_owner] = false;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}