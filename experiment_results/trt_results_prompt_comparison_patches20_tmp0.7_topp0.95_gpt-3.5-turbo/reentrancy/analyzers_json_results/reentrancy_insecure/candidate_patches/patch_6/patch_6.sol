pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }
} 

// The changes made to the contract include:
// 1. Reordering the code to ensure that the state variable is updated before the external call is made
// 2. Updating the Solidity version to ^0.4.24 to ensure that the latest security patches are applied
// 3. Simplifying the require statement to improve readability