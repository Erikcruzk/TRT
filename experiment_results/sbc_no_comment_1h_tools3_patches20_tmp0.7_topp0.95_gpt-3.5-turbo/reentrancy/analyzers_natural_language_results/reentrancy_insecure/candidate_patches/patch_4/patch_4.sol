pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Reentrant call detected");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");

        locked[msg.sender] = true;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success, "Transfer failed");
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
}