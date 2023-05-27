pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool locked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        require(!locked);
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
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

// Changes made:
// - Added "public" visibility modifier to all functions
// - Added a boolean variable "locked" to prevent reentrancy
// - Used "require" instead of "if-throw"
// - Moved the balance update before the send call to prevent reentrancy
// - Added a check to make sure the send call was successful and revert the transaction if it failed