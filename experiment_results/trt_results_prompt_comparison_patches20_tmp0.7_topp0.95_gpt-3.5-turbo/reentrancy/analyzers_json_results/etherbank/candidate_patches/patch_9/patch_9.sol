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
        require(msg.sender.call.value(amountToWithdraw)());
    }
} 

// Changes made:
// 1. Added visibility specifier "public" to all functions.
// 2. Added the "payable" modifier to addToBalance() function to allow for receiving ether.
// 3. Reordered the code in withdrawBalance() to prevent re-entrancy attacks.
// 4. Added "require" statement to check for successful external call and return an error if not successful.