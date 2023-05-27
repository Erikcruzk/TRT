pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); // Use msg.sender instead of tx.origin for authorization control
        require(_recipient != address(0)); // Check that recipient address is not null
        _recipient.transfer(this.balance);
    }
}