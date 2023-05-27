pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) public constant returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];

        require(msg.sender.send(amountToWithdraw));
        userBalances[msg.sender] = 0;
    }
}