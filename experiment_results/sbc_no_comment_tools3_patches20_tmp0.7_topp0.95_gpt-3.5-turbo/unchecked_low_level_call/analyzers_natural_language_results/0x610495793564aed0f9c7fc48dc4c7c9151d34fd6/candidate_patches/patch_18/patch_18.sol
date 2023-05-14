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
        owner.transfer(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        owner.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner {
        require(_target != address(0));
        _target.call.value(_value)(_data);
    }
}