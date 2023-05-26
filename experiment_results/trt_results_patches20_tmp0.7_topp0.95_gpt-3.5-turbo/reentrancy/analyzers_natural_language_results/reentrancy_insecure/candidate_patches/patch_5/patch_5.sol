pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private reEntrancyMutex;

    function withdrawBalance() public {
        require(!reEntrancyMutex[msg.sender]); //Check if the sender is already in the function
        reEntrancyMutex[msg.sender] = true; //Set the reEntrancyMutex to true
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); //Perform the external call
        reEntrancyMutex[msg.sender] = false; //Set the reEntrancyMutex to false
    }
}