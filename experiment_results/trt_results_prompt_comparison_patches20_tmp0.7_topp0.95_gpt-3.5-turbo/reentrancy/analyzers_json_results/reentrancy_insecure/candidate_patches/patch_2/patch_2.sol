pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private reentrancyLock;

    function withdrawBalance() public {
        require(!reentrancyLock[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);

        reentrancyLock[msg.sender] = true;
        userBalances[msg.sender] = 0;

        require(msg.sender.call.value(amountToWithdraw)(""));
        reentrancyLock[msg.sender] = false;
    }

    function depositBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}