pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) locked;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        require(!locked[msg.sender], "Account is locked");
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender], "Account is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
}