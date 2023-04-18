pragma solidity ^0.4.24;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Set user balance to zero before sending funds
        require(msg.sender.call.value(amountToWithdraw)()); // Send funds after setting user balance to zero
    }
}