pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) public {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner);
        _recipient.transfer(address(this).balance);
    }
}