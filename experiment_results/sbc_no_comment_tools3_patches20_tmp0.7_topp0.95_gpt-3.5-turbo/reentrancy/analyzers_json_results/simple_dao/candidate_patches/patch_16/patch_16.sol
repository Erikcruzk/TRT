pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) payable {
        require(!frozenAccount[to]);
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res);
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
    
    function freezeAccount(address to) {
        frozenAccount[to] = true;
    }
    
    function unfreezeAccount(address to) {
        frozenAccount[to] = false;
    }
}