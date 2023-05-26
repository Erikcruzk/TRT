pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) locked;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(userBalances[msg.sender] > 0, "Insufficient balance");
        require(!locked[msg.sender], "Withdrawal already in progress");
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        if (!(msg.sender.call.value(amountToWithdraw)())) {
            locked[msg.sender] = false;
            userBalances[msg.sender] = amountToWithdraw;
            revert("Withdrawal failed");
        }
        locked[msg.sender] = false;
    }
}