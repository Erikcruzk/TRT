pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); // use msg.sender instead of tx.origin for authorization
        require(_recipient != address(0)); // prevent sending ether to address 0x0
        _recipient.transfer(address(this).balance);
    }
}