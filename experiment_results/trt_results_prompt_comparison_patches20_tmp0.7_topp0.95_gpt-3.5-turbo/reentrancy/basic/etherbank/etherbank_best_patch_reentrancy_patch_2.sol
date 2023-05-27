pragma solidity ^0.4.18;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) public constant returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        require(msg.value > 0);
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }
}