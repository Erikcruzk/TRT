pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lockedAccounts;

    function withdrawBalance() public {
        require(!lockedAccounts[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        lockedAccounts[msg.sender] = true;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        lockedAccounts[msg.sender] = false;
    }
}