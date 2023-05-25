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
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res);
        locked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes Made:
// 1. Added a mapping 'locked' to keep track of users that are locked during the withdrawal process.
// 2. Added a require statement to check if the sender has sufficient credit and is not locked before withdrawing.
// 3. Moved the line that subtracts the amount from the sender's credit before the external call to prevent reentrancy.
// 4. Added a require statement to check if the external call was successful.
// 5. Added a line to unlock the sender after the external call is completed.