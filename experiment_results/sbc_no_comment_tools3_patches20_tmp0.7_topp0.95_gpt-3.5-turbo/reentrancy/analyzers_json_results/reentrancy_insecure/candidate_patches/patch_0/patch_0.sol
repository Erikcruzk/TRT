pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false;
    }
} 

// Explanation:
// In the original contract, the external call to the user-defined address is executed before the state variable is updated. 
// This can allow an attacker to call the function repeatedly, re-entering the contract and manipulating the state variables to their advantage.
// To fix this, we need to ensure that the state variables are updated before making the external call. 
// Additionally, we need to implement a reentrancy guard by adding a locked mapping to prevent multiple calls from the same user. 
// The locked mapping ensures that the function will only execute once per user, even if it is called multiple times in quick succession.