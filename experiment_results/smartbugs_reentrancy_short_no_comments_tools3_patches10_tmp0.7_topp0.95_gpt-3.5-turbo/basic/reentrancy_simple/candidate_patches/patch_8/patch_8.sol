pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;
    bool locked;

    function getBalance(address u) constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() payable{
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance(){
        require(!locked);
        locked = true;
        uint amountToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if( ! (msg.sender.call.value(amountToWithdraw)() ) ){
            throw;
        }
        locked = false;
    }
}