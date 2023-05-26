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
        credit[msg.sender] -= amount;
        locked[msg.sender] = true;
        if (!msg.sender.call.value(amount)()) {
            revert(); // revert if external call fails
        }
        locked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}