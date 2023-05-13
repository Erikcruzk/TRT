pragma solidity ^0.5.0;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address payable to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount, "Insufficient balance");
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}