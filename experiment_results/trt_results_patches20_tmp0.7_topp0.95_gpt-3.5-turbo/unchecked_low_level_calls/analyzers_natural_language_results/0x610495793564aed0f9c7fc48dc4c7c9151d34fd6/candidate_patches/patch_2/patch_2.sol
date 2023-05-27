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
        require(address(this).balance > 0); // check if there is a balance to withdraw
        owner.transfer(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(address(this).balance >= _value); // check if there is enough balance to withdraw
        owner.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner returns(bool) {
        require(_target.call.value(_value)(_data)); // check if the external call was successful
        return true;
    }
}