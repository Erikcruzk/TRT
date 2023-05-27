pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // added require statement for safety
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount); // changed to transfer() for safer withdrawal
    }

    function queryCredit(address to) public view returns (uint) { // added view keyword for immutability
        return credit[to];
    }
}