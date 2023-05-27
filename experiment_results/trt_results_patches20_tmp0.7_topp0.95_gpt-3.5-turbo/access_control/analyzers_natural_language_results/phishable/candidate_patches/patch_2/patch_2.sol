pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public onlyOwner {
        require(_recipient != address(0));
        _recipient.transfer(address(this).balance);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}