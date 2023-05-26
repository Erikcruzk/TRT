pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!locked[msg.sender]); // prevent reentrancy
        require(credit[msg.sender] >= amount);
        locked[msg.sender] = true; // lock the sender's account
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res); // ensure the external call was successful
        locked[msg.sender] = false; // unlock the sender's account
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}