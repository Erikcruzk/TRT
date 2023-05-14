pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // added require statement
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res); // added require statement
    }

    function queryCredit(address to) public view returns (uint) { // added view keyword
        return credit[to];
    }
}