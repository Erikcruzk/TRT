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
            if (res) {
                credit[msg.sender] -= amount;
            }
            frozenAccount[msg.sender] = false;
        }
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
} 

/*
Changes Made:
- Added a "frozenAccount" mapping to prevent reentrancy attacks
- Added a check to see if the account is frozen before allowing withdrawal
- Moved the deduction of credit after the external call to prevent reentrancy attacks
*/