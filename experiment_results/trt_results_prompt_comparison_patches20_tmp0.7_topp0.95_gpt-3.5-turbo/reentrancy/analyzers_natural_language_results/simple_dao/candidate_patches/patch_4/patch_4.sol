pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        require(!locked[to], "Account is locked.");
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!locked[msg.sender], "Account is locked.");
        require(credit[msg.sender] >= amount, "Insufficient funds.");
        locked[msg.sender] = true;
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res, "Withdrawal failed.");
        locked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}