pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        locked = true;
        userBalances[msg.sender] = 0;
        locked = false;
        require(msg.sender.call.value(amountToWithdraw)());
    }
}