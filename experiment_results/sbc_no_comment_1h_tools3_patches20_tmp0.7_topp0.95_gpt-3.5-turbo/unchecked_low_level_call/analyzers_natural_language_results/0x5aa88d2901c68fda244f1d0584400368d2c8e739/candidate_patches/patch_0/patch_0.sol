pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function execute(address _to, uint _value, bytes _data) public {
        require(msg.sender == owner);
        require(_to.call.value(_value)(_data));
    }

    function multiply(address _to) public payable {
        require(msg.value > 0);
        if (_to.call.value(msg.value * 3)()) {
            // multiplication successful
        } else {
            // multiplication failed
            revert();
        }
    }
}