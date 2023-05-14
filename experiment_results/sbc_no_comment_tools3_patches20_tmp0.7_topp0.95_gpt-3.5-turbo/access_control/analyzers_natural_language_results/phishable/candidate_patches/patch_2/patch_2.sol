pragma solidity ^0.8.0;

contract Phishable {
    address payable public owner;

    constructor(address payable _owner) {
        owner = _owner;
    }

    receive() external payable {}

    function withdrawAll(address payable _recipient) public {
        require(msg.sender == owner, "Only contract owner can withdraw");
        _recipient.transfer(address(this).balance);
    }
}