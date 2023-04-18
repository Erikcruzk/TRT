pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;
    bool private locked;

    function getBalance(address u) public constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() public payable{
        require(!locked);
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public{
        require(!locked);
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        locked = true;
        if(!msg.sender.call.value(balance)()){
            throw;
        }
        locked = false;
    }
}