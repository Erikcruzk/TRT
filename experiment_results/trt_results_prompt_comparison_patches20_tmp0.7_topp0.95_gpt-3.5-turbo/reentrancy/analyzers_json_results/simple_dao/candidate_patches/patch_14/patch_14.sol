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
        msg.sender.transfer(amount);
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }

    function freezeAccount(address to) {
        require(msg.sender == owner);
        frozenAccount[to] = true;
    }

    function unfreezeAccount(address to) {
        require(msg.sender == owner);
        frozenAccount[to] = false;
    }
}