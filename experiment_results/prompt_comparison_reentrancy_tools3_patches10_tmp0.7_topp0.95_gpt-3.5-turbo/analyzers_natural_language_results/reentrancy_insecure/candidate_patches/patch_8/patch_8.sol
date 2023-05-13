pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Withdrawal is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        locked = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
        userBalances[msg.sender] = 0;
        locked = false;
    }
}