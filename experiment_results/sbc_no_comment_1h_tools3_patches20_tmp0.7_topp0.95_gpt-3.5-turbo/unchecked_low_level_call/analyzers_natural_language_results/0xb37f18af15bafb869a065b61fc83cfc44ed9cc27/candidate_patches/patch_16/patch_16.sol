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
        require(address(this).balance >= _value, "Insufficient balance.");
        msg.sender.transfer(_value);
    }

    function sendMoney(address _target, uint _value) public onlyOwner {
        require(_target != address(0), "Invalid target address.");
        require(_value > 0, "Invalid value.");
        (bool success, ) = _target.call.value(_value)("");
        require(success, "External call failed.");
    }
}