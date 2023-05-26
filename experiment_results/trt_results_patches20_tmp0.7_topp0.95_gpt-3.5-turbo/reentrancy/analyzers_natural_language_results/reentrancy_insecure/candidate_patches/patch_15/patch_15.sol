pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lock;

    function withdrawBalance() public {
        require(!lock[msg.sender]); // Reentrancy guard
        lock[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        lock[msg.sender] = false;
    }

    function depositBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint) {
        return userBalances[msg.sender];
    }
}