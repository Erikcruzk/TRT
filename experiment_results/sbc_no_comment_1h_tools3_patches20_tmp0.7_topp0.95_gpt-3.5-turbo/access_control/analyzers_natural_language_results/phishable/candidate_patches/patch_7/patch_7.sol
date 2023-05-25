pragma solidity ^0.4.22;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function() public payable {}

    function withdrawAll(address _recipient) public {
        require(msg.sender == owner); //changed tx.origin to msg.sender for better security
        require(_recipient != address(0)); //added check to prevent sending funds to 0x0 address
        _recipient.transfer(address(this).balance);
    }
}