pragma solidity ^0.4.24;

contract SimpleWallet {
    address public owner = msg.sender;
    uint public depositsCount;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function() public payable {
        depositsCount++;
    }

    function withdrawAll() public onlyOwner {
        withdraw(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(address(this).balance >= _value); // Added check for contract balance
        msg.sender.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner returns(bool success) { // Added return value for external call
        require(_target.call.value(_value)(_data)); // Added check for external call success
        return true;
    }
}