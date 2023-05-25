pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount && !locked[msg.sender]); // add check for locked state
        locked[msg.sender] = true; // set locked state to true
        if(msg.sender.call.value(amount)()) {
            credit[msg.sender] -= amount;
            locked[msg.sender] = false; // set locked state to false
        }
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}

// Changes Made:
// - Added a new mapping 'locked' to track locked state of each account
// - Added a check for locked state in 'withdraw' function to prevent reentrancy
// - Moved the state modification after the external call to prevent reentrancy issues