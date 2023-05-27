pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private userWithdrawn;

    function withdrawBalance() public {
        require(userBalances[msg.sender] > 0, "Insufficient balance");
        require(!userWithdrawn[msg.sender], "Funds already withdrawn");

        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        userWithdrawn[msg.sender] = true;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdraw failed");
    }
}