pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        require(msg.value > 0);
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(userBalances[msg.sender] > 0);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }
}