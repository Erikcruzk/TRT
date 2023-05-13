pragma solidity ^0.5.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Reentrancy protection");
        locked = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked = false;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
}