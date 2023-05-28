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
        require(address(this).balance > 0);
        owner.transfer(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(_value <= address(this).balance);
        owner.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner returns(bool) {
        require(_target.call.value(_value)(_data));
        return true;
    }
}