pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) reentrancyLock;

    function getBalance(address user) constant public returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        require(!reentrancyLock[msg.sender]);

        reentrancyLock[msg.sender] = true;
        userBalances[msg.sender] = 0;
        if (!msg.sender.call.value(amountToWithdraw)()) {
            revert();
        }
        reentrancyLock[msg.sender] = false;
    }
}