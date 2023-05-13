pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        if(!res) {
            credit[msg.sender] += amount;
        }
    }

    function queryCredit(address to) view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address target) {
        frozenAccount[target] = true;
    }

    function unfreezeAccount(address target) {
        frozenAccount[target] = false;
    }
}