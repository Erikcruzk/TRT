pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount && !locked[msg.sender]);
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
// 1. Added a mapping to keep track of locked accounts to prevent reentrancy attacks
// 2. Changed the withdraw function to use the 'require' statement to check for sufficient funds and unlocked account before proceeding with the withdrawal
// 3. Added a 'locked' flag to the withdraw function to prevent reentrancy attacks
// 4. Changed the 'withdraw' function to use the 'transfer' function instead of an external call to prevent reentrancy attacks