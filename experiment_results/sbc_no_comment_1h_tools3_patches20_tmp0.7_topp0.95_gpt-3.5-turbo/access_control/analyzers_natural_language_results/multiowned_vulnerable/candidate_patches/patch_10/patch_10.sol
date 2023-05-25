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

    function newOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != address(0));
        owners[_owner] = true;
        return true;
    }

    function deleteOwner(address _owner) external onlyOwner returns (bool) {
        require(
            owners[_owner] && (_owner != root || msg.sender == root)
        );
        owners[_owner] = false;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        msg.sender.transfer(this.balance);
    }

    function() public payable {}
}