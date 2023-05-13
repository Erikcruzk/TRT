pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private withdrawn;

    function withdrawBalance() public {
        require(!withdrawn[msg.sender], "You have already withdrawn your balance.");
        uint amountToWithdraw = userBalances[msg.sender];

        withdrawn[msg.sender] = true;
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed.");
    }
}