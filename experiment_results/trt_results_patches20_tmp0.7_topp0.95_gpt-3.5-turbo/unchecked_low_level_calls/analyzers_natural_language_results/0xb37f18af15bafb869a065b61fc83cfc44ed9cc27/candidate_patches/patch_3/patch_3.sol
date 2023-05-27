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
        require(address(this).balance > 0); // added require statement to check if there are funds to withdraw
        owner.transfer(address(this).balance);
    }

    function withdraw(uint _value) public onlyOwner {
        require(_value <= address(this).balance); // added require statement to check if there are enough funds to withdraw
        owner.transfer(_value);
    }

    function sendMoney(address _target, uint _value) public onlyOwner {
        require(_target.call.value(_value)()); // added require statement to check if external call was successful
    }
}