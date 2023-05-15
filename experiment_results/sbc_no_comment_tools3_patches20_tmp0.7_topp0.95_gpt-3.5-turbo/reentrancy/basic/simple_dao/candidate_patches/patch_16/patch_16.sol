pragma solidity ^0.8.0;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) payable public {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount, "Insufficient balance");
        bool res = payable(msg.sender).send(amount);
        require(res, "Transfer failed");
        credit[msg.sender] -= amount;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}