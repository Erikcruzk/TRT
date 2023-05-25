pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); // Changed tx.origin to msg.sender
        require(_recipient != address(0)); // Added check to ensure recipient address is not 0x0
        _recipient.transfer(address(this).balance); // Changed this.balance to address(this).balance
    }
}