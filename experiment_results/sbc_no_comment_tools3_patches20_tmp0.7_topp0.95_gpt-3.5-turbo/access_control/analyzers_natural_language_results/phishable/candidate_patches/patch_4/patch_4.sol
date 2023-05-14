pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) public {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); // changed tx.origin to msg.sender for security
        _recipient.transfer(address(this).balance); // added address() to make it compatible with newer solidity versions
    }
}