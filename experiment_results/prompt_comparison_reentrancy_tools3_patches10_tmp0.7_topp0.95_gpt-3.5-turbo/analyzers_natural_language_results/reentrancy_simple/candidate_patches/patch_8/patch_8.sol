pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) withdrawn;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!withdrawn[msg.sender]);
        uint balanceToWithdraw = userBalance[msg.sender];
        withdrawn[msg.sender] = true;
        userBalance[msg.sender] = 0;
        if (!(msg.sender.call.value(balanceToWithdraw)())) {
            throw;
        }
    }
}