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
        require(address(this).balance > 0); // added require statement to check if there is balance in the contract before withdrawing
        owner.transfer(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(_value <= address(this).balance); // added require statement to check if the requested amount is less than or equal to the contract balance
        msg.sender.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner {
        require(_target.call.value(_value)(_data)); // added require statement to check if the external call was successful
    }
}