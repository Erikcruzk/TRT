pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public isLocked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!isLocked[msg.sender], "Account is locked");
        require(credit[msg.sender] >= amount, "Insufficient balance");
        isLocked[msg.sender] = true;
        bool res = msg.sender.call.value(amount)();
        require(res, "External call failed");
        credit[msg.sender] -= amount;
        isLocked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}