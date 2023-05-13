pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;

    function withdrawBalance() public {
        require(userBalances[msg.sender] > 0, "Insufficient balance.");
        
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed.");
    }
}