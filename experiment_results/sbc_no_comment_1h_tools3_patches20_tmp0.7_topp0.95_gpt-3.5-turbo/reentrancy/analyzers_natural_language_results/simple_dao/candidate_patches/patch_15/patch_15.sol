pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!locked[msg.sender]);
        require(credit[msg.sender] >= amount);
        locked[msg.sender] = true;
        msg.sender.transfer(amount);
        credit[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes Made:
// - Added a mapping to keep track of locked accounts to prevent reentrancy attacks
// - Added require statements to ensure the account is not locked and the user has enough credit before executing withdraw function
// - Replaced call function with transfer function to avoid reentrancy vulnerability
// - Made all functions public for accessibility