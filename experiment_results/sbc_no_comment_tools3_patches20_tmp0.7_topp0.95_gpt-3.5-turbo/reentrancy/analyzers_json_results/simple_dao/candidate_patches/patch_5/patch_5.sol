pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes Made:
// 1. Added visibility modifiers to functions
// 2. Replaced if statement with require statement to check condition
// 3. Moved credit[msg.sender] -= amount; before the external call to prevent reentrancy vulnerability
// 4. Added require statement to check if external call was successful