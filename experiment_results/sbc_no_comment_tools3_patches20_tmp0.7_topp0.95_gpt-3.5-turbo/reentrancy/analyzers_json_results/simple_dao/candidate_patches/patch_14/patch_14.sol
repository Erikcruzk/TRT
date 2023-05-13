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
// - Added explicit visibility modifiers to functions
// - Added require statement to check if user has enough credit before withdrawal
// - Moved credit[msg.sender] -= amount; statement before the external call to prevent reentrancy vulnerability
// - Added require statement to check if external call was successful after the transfer of ether