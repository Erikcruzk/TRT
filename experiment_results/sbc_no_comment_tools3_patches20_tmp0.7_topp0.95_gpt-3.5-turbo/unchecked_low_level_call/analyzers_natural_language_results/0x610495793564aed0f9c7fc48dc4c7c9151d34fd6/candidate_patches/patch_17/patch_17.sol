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
        require(address(this).balance >= _value);
        msg.sender.transfer(_value);
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner {
        require(_target != address(0), "Invalid target address");
        require(_value <= address(this).balance, "Insufficient balance in the contract");
        bool success;
        bytes memory returnData;
        (success, returnData) = _target.call.value(_value)(_data);
        require(success, "Low level call failed");
    }
}