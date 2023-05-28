pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if user is already withdrawing
        locked[msg.sender] = true; // lock user from re-entering

        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        bool success = msg.sender.send(amountToWithdraw);
        require(success);

        locked[msg.sender] = false; // release the lock
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
}