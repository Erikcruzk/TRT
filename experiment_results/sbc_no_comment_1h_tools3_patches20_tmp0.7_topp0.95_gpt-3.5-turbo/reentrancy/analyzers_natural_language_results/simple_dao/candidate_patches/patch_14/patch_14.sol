pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount && !locked[msg.sender]);
        locked[msg.sender] = true;
        msg.sender.transfer(amount);
        credit[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}