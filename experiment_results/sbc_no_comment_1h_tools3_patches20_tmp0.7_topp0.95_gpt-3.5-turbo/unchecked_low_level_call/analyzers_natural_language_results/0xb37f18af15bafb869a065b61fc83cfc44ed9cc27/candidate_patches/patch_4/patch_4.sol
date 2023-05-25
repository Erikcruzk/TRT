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
        require(address(this).balance >= _value); // Check if contract has enough balance
        owner.transfer(_value); // Transfer the requested amount to the owner
    }

    function sendMoney(address _target, uint _value) public onlyOwner {
        require(_target != address(0)); // Check if target address is valid
        require(address(this).balance >= _value); // Check if contract has enough balance
        require(_target.call.value(_value)()); // Check if the call was successful
    }
}