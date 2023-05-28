pragma solidity ^0.5.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isCurrentlyWithdrawn;

    function withdrawBalance() public {
        require(!isCurrentlyWithdrawn[msg.sender]); // Only allow one withdrawal at a time
        isCurrentlyWithdrawn[msg.sender] = true;

        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        isCurrentlyWithdrawn[msg.sender] = false;
    }

    function depositBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }
}