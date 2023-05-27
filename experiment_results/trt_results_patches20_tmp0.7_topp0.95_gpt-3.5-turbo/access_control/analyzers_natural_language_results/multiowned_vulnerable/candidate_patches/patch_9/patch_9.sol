pragma solidity ^0.4.23;

contract MultiOwnable {
    address public root;
    mapping(address => address) public owners;

    constructor() public {
        root = msg.sender;
        owners[root] = root;
    }

    modifier onlyOwner() {
        require(owners[msg.sender] != 0);
        _;
    }

    function newOwner(address _owner) external onlyOwner returns (bool) {
        require(_owner != 0);
        owners[_owner] = msg.sender;
        return true;
    }

    function deleteOwner(address _owner) external onlyOwner returns (bool) {
        require(
            owners[_owner] == msg.sender ||
                (owners[_owner] != 0 && msg.sender == root)
        );
        owners[_owner] = 0;
        return true;
    }
}

contract TestContract is MultiOwnable {
    function withdrawAll() public onlyOwner {
        require(address(this).balance > 0);
        msg.sender.transfer(address(this).balance);
    }

    function() public payable {}
}