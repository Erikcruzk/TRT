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
        require(userBalances[msg.sender] > 0 && !locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
}