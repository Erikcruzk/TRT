pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;

    function getBalance(address u) constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() payable{
        require(userBalance[msg.sender] + msg.value >= userBalance[msg.sender]); // prevent integer overflow
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance(){
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        require(msg.sender.call.value(balanceToWithdraw)()); // ensure withdrawal before updating balance
    }
}