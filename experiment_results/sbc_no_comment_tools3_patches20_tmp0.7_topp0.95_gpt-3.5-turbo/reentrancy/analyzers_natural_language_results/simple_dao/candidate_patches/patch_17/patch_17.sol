pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount, "Insufficient balance"); // Add a require statement to check if the sender has sufficient balance
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)(); // Move the external call to the end of the function
        require(res, "External call failed"); // Add a require statement to check if the external call was successful
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}