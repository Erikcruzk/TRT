pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool locked;

    function getBalance(address u) constant public returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        require(!locked);
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalance[msg.sender];
        require(amountToWithdraw > 0);
        userBalance[msg.sender] = 0;
        locked = true;
        if (!(msg.sender.call.value(amountToWithdraw)())) {
            throw;
        }
        locked = false;
    }
}