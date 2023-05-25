pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); // use msg.sender instead of tx.origin for access control
        require(_recipient != address(0)); // ensure recipient address is valid
        _recipient.transfer(address(this).balance);
    }
}