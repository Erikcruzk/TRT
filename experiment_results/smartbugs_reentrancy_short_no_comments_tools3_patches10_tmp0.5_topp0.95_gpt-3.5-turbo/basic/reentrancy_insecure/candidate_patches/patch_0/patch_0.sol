pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdraw already in progress");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdraw failed");
        locked[msg.sender] = false;
    }
} 

// The repaired contract adds a 'locked' mapping that prevents reentrancy attacks by checking if a withdraw is already in progress for a specific user. It also includes additional require statements to ensure that the user has a balance to withdraw and that the withdraw call was successful. Additionally, the contract has been updated to Solidity version 0.8.0.