pragma solidity ^0.4.24;

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

// Changes Made:
// 1. Added "public" modifier to all functions for better accessibility.
// 2. Used the "require" statement to check if the user has enough credit to withdraw.
// 3. Transferred the funds to the user after the credit balance was updated to prevent reentrancy attack.
// 4. Upgraded the Solidity version to 0.4.24 to address any potential security vulnerabilities.