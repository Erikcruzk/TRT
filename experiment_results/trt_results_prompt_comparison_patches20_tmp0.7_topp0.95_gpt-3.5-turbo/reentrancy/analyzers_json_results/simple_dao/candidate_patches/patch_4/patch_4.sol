pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        if (credit[msg.sender] >= amount) {
            credit[msg.sender] -= amount;
            require(msg.sender.call.value(amount)());
        }
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes Made:
// 1. Added public keyword to functions for better visibility.
// 2. Moved the subtraction of amount from credit[msg.sender] before the external call to prevent reentrancy attacks.
// 3. Added require statement after the external call to check if it was successful.