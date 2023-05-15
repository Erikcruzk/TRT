pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool locked;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!locked);
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        locked = true;
        if (!msg.sender.send(balance)) {
            locked = false;
            userBalance[msg.sender] = balance;
            revert();
        }
        locked = false;
    }
}