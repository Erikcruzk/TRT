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
        require(_value <= address(this).balance); // Added a require statement to check if the requested amount is less than or equal to the contract balance
        msg.sender.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner {
        require(_target.call.value(_value)(_data)); // Added a require statement to check if the call was successful
    }
}