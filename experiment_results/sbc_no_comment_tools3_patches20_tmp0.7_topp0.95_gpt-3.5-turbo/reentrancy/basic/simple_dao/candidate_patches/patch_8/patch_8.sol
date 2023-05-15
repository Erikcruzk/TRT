pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount, "Insufficient funds");
        credit[msg.sender] -= amount;
        bool res = msg.sender.send(amount);
        require(res, "Transaction failed");
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}