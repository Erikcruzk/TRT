pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
}