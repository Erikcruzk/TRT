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
        require(address(this).balance >= _value); // check if contract has enough balance
        owner.transfer(_value); // transfer funds to owner
    }

    function sendMoney(
        address _target,
        uint _value,
        bytes _data
    ) public onlyOwner returns (bool) {
        require(_target != address(0)); // check if target address is valid
        require(_value <= address(this).balance); // check if contract has enough balance
        return _target.call.value(_value)(_data);
    }
}