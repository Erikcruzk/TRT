pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked);
        locked = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked = false;
    }
} 

// The repaired contract includes a reentrancy guard to prevent multiple calls to the function before it finishes executing. It sets a boolean flag "locked" to true at the beginning of the function and sets it back to false at the end. The "locked" flag prevents the function from being called again before it finishes execution. Additionally, the state variable "userBalances" is updated before the external call to prevent any state changes from being executed after the call.