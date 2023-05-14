pragma solidity ^0.8.0;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    receive() external payable {}

    function withdrawAll(address payable _recipient) public {
        require(msg.sender == owner, "Only owner can withdraw.");
        _recipient.transfer(address(this).balance);
    }
}