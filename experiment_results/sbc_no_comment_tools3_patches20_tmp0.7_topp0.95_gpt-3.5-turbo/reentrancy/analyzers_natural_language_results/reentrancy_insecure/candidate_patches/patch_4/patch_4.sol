pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);

        locked[msg.sender] = true;
        msg.sender.transfer(amountToWithdraw);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
}