pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public donated;

    function donate(address to) payable {
        credit[to] += msg.value;
        donated[to] = true;
    }

    function withdraw(uint amount) {
        if (credit[msg.sender] >= amount && donated[msg.sender]) {
            credit[msg.sender] -= amount;
            bool res = msg.sender.call.value(amount)();
        }
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
}