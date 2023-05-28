pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lock;

    function withdrawBalance() public {
        require(!lock[msg.sender]); // check if the user is already in the withdraw process
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        lock[msg.sender] = true; // lock the user
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        lock[msg.sender] = false; // unlock the user
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}