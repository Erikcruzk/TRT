pragma solidity ^0.4.0;

contract EtherBank{
    mapping (address => uint) userBalances;

    function getBalance(address user) public view returns(uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }    
} 

// Changes made:
// - Made the getBalance function public and view
// - Made the addToBalance function public and payable
// - Changed the withdrawBalance function to first set the user's balance to 0, then transfer the amount to the user using the transfer function (prevents reentrancy attack)