pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public lock;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(lock[msg.sender] == false);
        require(credit[msg.sender] >= amount);
        lock[msg.sender] = true;
        msg.sender.transfer(amount);
        credit[msg.sender] -= amount;
        lock[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}