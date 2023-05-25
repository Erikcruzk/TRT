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
        require(!locked[msg.sender]); // check if the caller is already in the middle of a withdraw
        locked[msg.sender] = true; // set the caller as locked
        uint balance = userBalance[msg.sender]; // store the balance in a local variable
        userBalance[msg.sender] = 0; // set the balance to zero before sending
        if (balance > 0) { // check if there is a balance to withdraw
            if (!(msg.sender.call.value(balance)())) { // make the external call
                revert(); // revert the state if the call fails
            }
        }
        locked[msg.sender] = false; // unlock the caller
    }
}