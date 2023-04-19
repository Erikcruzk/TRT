pragma solidity ^0.4.24;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update balance before external call
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
}