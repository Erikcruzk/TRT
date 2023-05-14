pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        
        if (!(msg.sender.send(amountToWithdraw))) {
            revert();
        }
    }
}

// Changes made:
// 1. Added visibility keywords to functions
// 2. Added payable keyword to addToBalance function
// 3. Moved userBalances[msg.sender] = 0; above the external call to prevent reentrancy attack
// 4. Changed the external call from call() to send() and added a revert statement in case of failure