pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool private locked;

    function Reentrance() {
        locked = false;
    }

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        require(!locked);
        locked = true;
        userBalance[msg.sender] += msg.value;
        locked = false;
    }

    function withdrawBalance() {
        require(!locked);
        locked = true;
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(balanceToWithdraw)) {
            userBalance[msg.sender] = balanceToWithdraw;
        }
        locked = false;
    }
}