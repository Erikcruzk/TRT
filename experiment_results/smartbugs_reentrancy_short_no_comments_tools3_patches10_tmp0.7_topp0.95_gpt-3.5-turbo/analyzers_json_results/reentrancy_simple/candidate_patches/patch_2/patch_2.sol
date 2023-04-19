pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;

    function getBalance(address u) constant public returns(uint){
        return userBalance[u];
    }

    function addToBalance() public payable{
        require(userBalance[msg.sender] + msg.value >= userBalance[msg.sender]);
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(balance);
    }
}