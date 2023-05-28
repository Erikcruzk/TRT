pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // Check if sender has sufficient credit
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)(); // Send the amount to the sender
        require(res); // Check if the transaction was successful
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}