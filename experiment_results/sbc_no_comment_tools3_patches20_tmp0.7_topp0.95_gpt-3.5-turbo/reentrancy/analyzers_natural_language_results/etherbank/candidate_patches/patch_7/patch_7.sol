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
        if (!(msg.sender.call.value(amountToWithdraw)())) {
            revert();
        }
    }
}

//Changes Made:
//1. Added visibility specifiers to functions
//2. Added 'payable' modifier to addToBalance function
//3. Moved the userBalances[msg.sender] = 0; line before the external call
//4. Replaced 'throw' with 'revert' in withdrawBalance function.