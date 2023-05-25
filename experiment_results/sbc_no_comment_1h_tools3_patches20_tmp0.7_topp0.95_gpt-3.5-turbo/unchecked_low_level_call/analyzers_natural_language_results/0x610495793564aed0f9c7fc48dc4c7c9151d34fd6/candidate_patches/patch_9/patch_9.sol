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
        owner.transfer(_value); // Transfer the value to the owner
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner returns (bool success) { // Add return value to check if call was successful
        require(_target != address(0)); // Check if target address is not empty
        require(_target.call.value(_value)(_data)); // Check if call was successful
        return true;
    }
}