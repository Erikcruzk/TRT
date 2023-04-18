pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;
    mapping (address => bool) locked;

    function getBalance(address u) constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() payable{
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance(){
        require(!locked[msg.sender]); // Prevent reentrancy
        locked[msg.sender] = true;
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if( !msg.sender.send(balance) ) {
            userBalance[msg.sender] = balance;
            locked[msg.sender] = false;
            revert();
        }
        locked[msg.sender] = false;
    }
}