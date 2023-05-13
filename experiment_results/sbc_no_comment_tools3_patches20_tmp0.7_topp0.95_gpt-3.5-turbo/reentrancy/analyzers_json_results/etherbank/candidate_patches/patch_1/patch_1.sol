pragma solidity ^0.4.0;

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

        if (!(msg.sender.call.value(amountToWithdraw)())) {
            revert();
        }
    }
} 

// Changes made:
// 1. Added 'public' visibility modifier to all functions to make them accessible outside the contract.
// 2. Added 'payable' modifier to 'addToBalance' function to enable receiving ether.
// 3. Moved setting 'userBalances[msg.sender] = 0;' before the external call in 'withdrawBalance' function to prevent reentrancy vulnerability.
// 4. Replaced 'throw' with 'revert()' in 'withdrawBalance' function as 'throw' is deprecated from Solidity version 0.5.0.