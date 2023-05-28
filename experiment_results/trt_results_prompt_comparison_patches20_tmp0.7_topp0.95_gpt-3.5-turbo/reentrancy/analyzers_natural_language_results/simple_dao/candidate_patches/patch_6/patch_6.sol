pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        if (!frozenAccount[msg.sender] && credit[msg.sender] >= amount) {
            frozenAccount[msg.sender] = true;
            if (msg.sender.call.value(amount)()) {
                credit[msg.sender] -= amount;
            }
            frozenAccount[msg.sender] = false;
        }
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
}