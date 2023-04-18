pragma solidity ^0.4.24;

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
        require(amountToWithdraw > 0);
        msg.sender.transfer(amountToWithdraw);
        userBalances[msg.sender] = 0;
    }
} 

// Changes made: 
// 1. Updated the Solidity version to ^0.4.24
// 2. Made the getBalance function view function
// 3. Added payable modifier to addToBalance function
// 4. Replaced throw with require in withdrawBalance function
// 5. Used transfer function to send ether to the user in withdrawBalance function