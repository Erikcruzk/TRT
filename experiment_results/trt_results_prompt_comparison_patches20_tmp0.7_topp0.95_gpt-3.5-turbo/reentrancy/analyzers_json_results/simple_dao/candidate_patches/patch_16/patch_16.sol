pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        require(credit[msg.sender] >= amount);
        require(!frozenAccount[msg.sender]);
        frozenAccount[msg.sender] = true;
        bool res = msg.sender.call.value(amount)();
        require(res);
        credit[msg.sender] -= amount;
        frozenAccount[msg.sender] = false;
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
} 

// Changes Made:
// 1. Added a new mapping to keep track of frozen accounts.
// 2. Added a require statement to check if the account is frozen before withdrawing.
// 3. Added a new line to freeze the account before performing an external call.
// 4. Added a require statement to check if the external call was successful.
// 5. Added a new line to unfreeze the account after the external call.