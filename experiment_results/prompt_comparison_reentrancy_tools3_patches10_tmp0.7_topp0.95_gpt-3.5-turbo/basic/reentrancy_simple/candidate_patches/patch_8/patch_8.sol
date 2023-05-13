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
        locked = true;
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(balanceToWithdraw)) {
            userBalance[msg.sender] = balanceToWithdraw;
            locked = false;
            revert();
        }
        locked = false;
    }
}

// Changes Made:
// 1. Added a boolean 'locked' variable to prevent reentrancy attacks.
// 2. Added 'public' keyword to all the functions.
// 3. Used the 'require' function to check the 'locked' variable.
// 4. Used 'send' instead of 'call' to transfer funds and added a check for successful transfer.
// 5. Reverted the transaction if the transfer fails and set the 'locked' variable to false.