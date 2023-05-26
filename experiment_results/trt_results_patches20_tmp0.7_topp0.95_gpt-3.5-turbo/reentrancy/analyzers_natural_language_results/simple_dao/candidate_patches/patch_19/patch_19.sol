pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        require(!locked[msg.sender]);
        require(credit[msg.sender] >= amount);
        locked[msg.sender] = true;
        bool res = msg.sender.call.value(amount)();
        require(res);
        credit[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
}