pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public Owner;

    function MultiplicatorX3() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address _to, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_to.call.value(msg.value)(_data));
    }

    function multiplicate(address _to) public payable {
        require(msg.value > 0);
        if (_to.call.value(msg.value * 3)()) {
            return;
        }
        revert();
    }
}