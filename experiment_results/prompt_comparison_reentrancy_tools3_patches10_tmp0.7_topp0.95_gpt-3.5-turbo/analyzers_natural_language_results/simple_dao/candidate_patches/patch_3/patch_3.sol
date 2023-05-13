pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes Made
// - Added "public" visibility modifier to all functions
// - Replaced the external call with "transfer" to prevent reentrancy attack
// - Added require statement to validate that the sender has enough credit before withdrawing funds.