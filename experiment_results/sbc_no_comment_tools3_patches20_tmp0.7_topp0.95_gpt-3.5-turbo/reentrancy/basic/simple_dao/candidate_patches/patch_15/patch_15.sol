pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // added require statement to check if user has enough credit
        credit[msg.sender] -= amount;
        bool res = msg.sender.send(amount); // updated call.value to send for better security
        require(res); // added require statement to check if transfer was successful
    }

    function queryCredit(address to) public view returns (uint) { // added view modifier for read-only function
        return credit[to];
    }
}