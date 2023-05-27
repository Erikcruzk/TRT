pragma solidity ^0.4.24;

contract SimpleWallet {
    address public owner;

    uint public depositsCount;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function() public payable {
        depositsCount++;
    }

    function withdrawAll() public onlyOwner {
        require(address(this).balance > 0);
        owner.transfer(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(address(this).balance >= _value);
        owner.transfer(_value);
    }

    function sendMoney(address _target, uint _value) public onlyOwner {
        require(_target != address(0));
        require(_value > 0);
        require(address(this).balance >= _value);
        _target.transfer(_value);
    }
}