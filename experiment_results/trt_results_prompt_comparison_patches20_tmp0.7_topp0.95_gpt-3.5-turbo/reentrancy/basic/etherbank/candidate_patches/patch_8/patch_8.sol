pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint256) userBalances;

    function getBalance(address user) public view returns (uint256) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint256 amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }
}