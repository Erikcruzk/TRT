pragma solidity ^0.8.0;

contract SimpleWallet {
    address public owner;

    uint public depositsCount;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    receive() external payable {
        depositsCount++;
    }

    function withdrawAll() public onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(msg.sender).transfer(balance);
    }

    function withdraw(uint _value) public onlyOwner {
        uint balance = address(this).balance;
        require(_value <= balance, "Insufficient balance to withdraw");
        payable(msg.sender).transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes memory _data
    ) public onlyOwner {
        (bool success,) = _target.call{value: _value}(_data);
        require(success, "External call failed");
    }
}