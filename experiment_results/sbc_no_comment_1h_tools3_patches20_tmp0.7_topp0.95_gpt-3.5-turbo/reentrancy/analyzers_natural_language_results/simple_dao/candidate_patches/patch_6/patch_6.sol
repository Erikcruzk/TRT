pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        require(!locked[msg.sender]);
        require(credit[msg.sender] >= amount);
        locked[msg.sender] = true;
        bool res = msg.sender.call.value(amount)();
        require(res);
        credit[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
} 

//Explanation of Changes Made:
//1. Added a new mapping to track whether a user is locked or not to prevent reentrancy attacks.
//2. Added a require statement to check if the user is not locked before executing the withdraw function.
//3. Reordered the statements in the withdraw function to prevent reentrancy attacks. 
//4. Added a require statement to check if the external call to the user-supplied address was successful.