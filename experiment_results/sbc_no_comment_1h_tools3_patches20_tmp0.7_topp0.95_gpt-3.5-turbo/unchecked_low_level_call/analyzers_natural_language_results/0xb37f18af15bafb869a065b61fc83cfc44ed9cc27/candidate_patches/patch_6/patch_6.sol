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
        require(address(this).balance > 0); // added check to ensure balance is greater than 0
        withdraw(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(address(this).balance >= _value); // added check to ensure balance is sufficient
        msg.sender.transfer(_value);
    }

    function sendMoney(address _target, uint _value) public onlyOwner {
        require(_target != address(0)); // added check to ensure target address is not null
        require(_value > 0); // added check to ensure value is greater than 0
        bool success = _target.call.value(_value)(); // added check for return value
        require(success); // added check for success of call
    }
}