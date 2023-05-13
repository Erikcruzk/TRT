pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked = false;
    }
} 

// The repaired contract adds a reentrancy guard by using a boolean variable 'locked' to prevent multiple calls to the withdrawBalance function. The state variable 'locked' is set to true at the beginning of the function and set to false after the external call to transfer funds back to the user. Additionally, the function now checks if the user has a positive balance before attempting to withdraw.