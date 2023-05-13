pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }
}