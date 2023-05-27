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
        require(address(this).balance > 0); // added check for non-zero balance
        withdraw(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(address(this).balance >= _value); // added check for sufficient balance
        msg.sender.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner returns(bool) { // added return value check
        require(_target.call.value(_value)(_data));
        return true;
    }
}