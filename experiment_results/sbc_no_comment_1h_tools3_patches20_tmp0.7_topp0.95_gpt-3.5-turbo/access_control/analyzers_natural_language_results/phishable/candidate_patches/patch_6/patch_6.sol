pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); // Use msg.sender instead of tx.origin
        require(_recipient != address(0)); // Prevent sending to the zero address
        _recipient.transfer(address(this).balance);
    }
}