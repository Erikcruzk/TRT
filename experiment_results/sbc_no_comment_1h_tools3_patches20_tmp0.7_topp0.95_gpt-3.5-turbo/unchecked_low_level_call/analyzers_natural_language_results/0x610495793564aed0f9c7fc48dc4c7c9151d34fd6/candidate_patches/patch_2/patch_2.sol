pragma solidity ^0.4.24;

contract SimpleWallet {
    address public owner;

    uint public depositsCount;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function() public payable {
        depositsCount++;
    }

    function withdrawAll() public onlyOwner {
        withdraw(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(address(this).balance >= _value); // check if contract has enough balance
        msg.sender.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner returns(bool success) {
        require(_target != address(0)); // check if target address is not null
        success = _target.call.value(_value)(_data);
    }
}