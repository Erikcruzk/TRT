pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);

        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;

        require(msg.sender.call.value(amountToWithdraw)());
    }
}