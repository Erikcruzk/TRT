pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) locked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if not already locked
        locked[msg.sender] = true; // Lock the user

        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;

        if (!msg.sender.call.value(balance)()) { // Send ether before unlocking
            revert();
        }

        locked[msg.sender] = false; // Unlock the user
    }
}