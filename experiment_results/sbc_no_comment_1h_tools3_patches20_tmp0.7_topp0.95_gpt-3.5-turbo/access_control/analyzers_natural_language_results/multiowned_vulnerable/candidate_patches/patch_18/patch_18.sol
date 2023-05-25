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

    function newOwner(address _owner) external returns (bool) {
        require(_owner != 0);
        require(owners[msg.sender]);
        owners[_owner] = true;
        return true;
    }

    function deleteOwner(address _owner) external onlyOwner returns (bool) {
        require(
            owners[_owner] && (msg.sender == root || msg.sender == _owner)
        );
        owners[_owner] = false;
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