pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isWithdrawn;

    function withdrawBalance() public {
        require(!isWithdrawn[msg.sender], "Already withdrawn");
        uint amountToWithdraw = userBalances[msg.sender];
        isWithdrawn[msg.sender] = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
    }
}