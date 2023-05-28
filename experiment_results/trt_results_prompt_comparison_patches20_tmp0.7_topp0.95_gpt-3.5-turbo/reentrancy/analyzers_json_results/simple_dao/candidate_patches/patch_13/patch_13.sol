pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount);
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        bool res = msg.sender.call.value(amount)();
        require(res);
        credit[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes made:
// 1. Added a mapping to check if a user is locked in the middle of a withdrawal
// 2. Added a require statement to check if the user has sufficient credit
// 3. Added a require statement to check if the user is not locked
// 4. Added a locking mechanism to prevent reentrancy attacks
// 5. Changed function visibility to public for better clarity.