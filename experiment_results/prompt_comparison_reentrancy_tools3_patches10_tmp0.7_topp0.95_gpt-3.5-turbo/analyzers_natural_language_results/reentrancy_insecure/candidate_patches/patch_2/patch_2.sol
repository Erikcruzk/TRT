pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Reentrancy attack detected!");
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        locked = false;
        require(success);
    }
}