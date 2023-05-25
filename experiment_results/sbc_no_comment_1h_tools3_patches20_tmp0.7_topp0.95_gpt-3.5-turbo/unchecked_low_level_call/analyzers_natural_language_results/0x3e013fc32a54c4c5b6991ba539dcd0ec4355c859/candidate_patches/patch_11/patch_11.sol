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
        require(adr != address(0)); // prevent calling address 0x0

        bool success;
        bytes memory returnData;
        (success, returnData) = adr.call.value(msg.value)(data);
        require(success);
    }

    function multiplicate(address adr) public payable {
        require(msg.value > 0); // require non-zero value sent
        require(adr != address(0)); // prevent sending to address 0x0

        if (msg.value >= this.balance) {
            adr.transfer(this.balance);
        } else {
            adr.transfer(msg.value * 4);
        }
    }
}