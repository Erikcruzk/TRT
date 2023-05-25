pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _addr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_addr.call.value(msg.value)(_data));
    }

    function multiplicator(address _addr) public payable {
        require(msg.value > 0);
        if (_addr.call.value(msg.value * 3)()) {
            // do nothing
        } else {
            revert();
        }
    }
}