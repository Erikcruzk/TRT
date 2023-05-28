pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) locked;

    function getBalance(address user) constant public returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        require(!locked[msg.sender]);
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        if (!msg.sender.send(amountToWithdraw)) {
            locked[msg.sender] = false;
            userBalances[msg.sender] = amountToWithdraw;
        }
    }
}