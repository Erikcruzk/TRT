pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) locked;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        require(!locked[msg.sender]);
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        if (!(msg.sender.call.value(amountToWithdraw)())) {
            revert();
        }
        locked[msg.sender] = false;
    }
}

// Changes Made:
// 1. Added a mapping to keep track of locked users to prevent reentrancy attacks.
// 2. Modified the getBalance() function to be view only.
// 3. Added require statements to prevent locked users from making transactions and to prevent withdrawing a balance of 0.
// 4. Moved the userBalances[msg.sender] = 0; statement above the external call to prevent reentrancy attacks. 
// 5. Added a locked[msg.sender] = true; statement before the external call to prevent reentrancy attacks.
// 6. Added a locked[msg.sender] = false; statement after the external call to release the lock. 
// 7. Removed the throw statement and replaced it with a revert statement for better error handling.