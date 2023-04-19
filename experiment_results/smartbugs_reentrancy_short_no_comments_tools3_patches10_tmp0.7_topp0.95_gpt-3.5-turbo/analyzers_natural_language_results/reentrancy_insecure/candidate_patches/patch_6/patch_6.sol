pragma solidity ^0.4.0;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update the user balance before sending the funds to avoid reentrancy attack
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
}