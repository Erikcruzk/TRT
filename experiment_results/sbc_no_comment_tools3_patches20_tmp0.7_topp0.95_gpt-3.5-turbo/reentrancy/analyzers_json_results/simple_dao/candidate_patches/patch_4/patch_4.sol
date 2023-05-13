pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        require(!frozenAccount[msg.sender]);
        if (credit[msg.sender] >= amount) {
            credit[msg.sender] -= amount;
            bool res = msg.sender.call.value(amount)();
        }
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
    
    function freezeAccount(address target, bool freeze) {
        frozenAccount[target] = freeze;
    }
}