pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); // Changed tx.origin to msg.sender for better security
        require(_recipient != address(0)); // Added a check for valid recipient address
        _recipient.transfer(address(this).balance);
    }
}