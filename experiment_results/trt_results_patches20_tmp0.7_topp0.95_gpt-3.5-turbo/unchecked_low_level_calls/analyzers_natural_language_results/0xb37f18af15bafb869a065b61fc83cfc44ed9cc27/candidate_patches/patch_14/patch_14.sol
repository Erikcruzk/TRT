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
        require(address(this).balance > 0); // Check if contract has balance before withdrawing
        owner.transfer(address(this).balance); // Transfer all balance to owner
    }

    function withdraw(uint _value) public onlyOwner {
        require(_value <= address(this).balance); // Check if contract has sufficient balance to withdraw
        owner.transfer(_value); // Transfer specified amount to owner
    }

    function sendMoney(address _target, uint _value) public onlyOwner {
        require(_target.call.value(_value)()); // Check if external call was successful and return value is true
    }
}