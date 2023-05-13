pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        if (credit[msg.sender] >= amount && !frozenAccount[msg.sender]) {
            frozenAccount[msg.sender] = true;
            bool res = msg.sender.call.value(amount)();
            credit[msg.sender] -= amount;
            frozenAccount[msg.sender] = false;
        }
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
} 

//Changes Made:
//1. Added a new mapping 'frozenAccount' to prevent reentrancy attack
//2. Modified the withdraw function to check if the account is not frozen before making the external call
//3. Added a line of code to freeze the account before making the external call and unfreeze it after that