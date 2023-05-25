pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        msg.sender.transfer(amountToWithdraw);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
}