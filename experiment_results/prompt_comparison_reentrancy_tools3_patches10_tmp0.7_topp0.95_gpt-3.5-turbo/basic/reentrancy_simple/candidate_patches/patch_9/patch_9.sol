pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool locked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked);
        locked = true;
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(balance);
        locked = false;
    }
}

// Changes Made:
// 1. Added "public" visibility modifier to functions.
// 2. Added a "locked" boolean variable to prevent reentrancy.
// 3. Used "require" instead of "if" to enforce the condition.
// 4. Moved the balance assignment before the transfer to prevent reentrancy.
// 5. Added a flag to lock the function during execution to prevent reentrancy.