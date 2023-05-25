pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) locked;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.call.value(balance)()) {
            revert();
        }
        locked[msg.sender] = false;
    }
}

// Explanation of Changes:
// - Added a mapping to keep track of locked accounts during withdrawal to prevent reentrancy
// - Moved the balance retrieval and modification before the external call to prevent reentrancy
// - Added a revert statement in case the external call fails