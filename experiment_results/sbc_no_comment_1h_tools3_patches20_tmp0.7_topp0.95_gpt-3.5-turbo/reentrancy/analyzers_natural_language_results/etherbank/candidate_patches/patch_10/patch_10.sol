pragma solidity ^0.4.0;

contract EtherBank {
    mapping(address => uint) userBalances;
    mapping(address => bool) internal locked;

    function getBalance(address user) public constant returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Add reentrancy guard
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Require non-zero balance
        locked[msg.sender] = true; // Lock the user's balance
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false; // Unlock the user's balance
    }
}