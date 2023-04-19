pragma solidity ^0.8.0;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update balance before transferring funds
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
    }
}